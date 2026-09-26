// session-delete-guard — refuses to delete sessions that are still in progress
// from the terminal UI.
//
// Why a client wrapper: the only delete entry point in the TUI is the native
// session list (/sessions), which calls the shared OpenCode client
// (context.client.session.remove). The list does not expose which row is
// selected, so a keymap layer cannot tell a running row from an idle one.
// Wrapping the client method blocks every path (key, Tab+Enter, mouse) and
// keeps the per-row decision accurate.
//
// Rules (options):
//   - includeWaiting: a session with a pending permission or question is also
//     protected (default true). Child/subagent sessions count as part of their
//     parent: if any family member is active, the whole tree is protected.
//   - includeQueued: if true, sessions with queued inbox prompts are protected
//     too (default false).
//   - sound: plays the attention sound together with the warning toast
//     (default true). The notice is throttled per burst.
//
// The server side (index.ts) is a no-op, same layout as exit-guard.
import { Plugin } from "@opencode/plugin/tui"
import type { Context } from "@opencode/plugin/tui/context"

const PATCHED = Symbol.for("session-delete-guard.patched")
const NOTIFY_INTERVAL = 1500

let lastNotify = 0

type Settings = {
  includeWaiting: boolean
  includeQueued: boolean
  sound: boolean
}

const DEFAULTS: Settings = {
  includeWaiting: true,
  includeQueued: false,
  sound: true,
}

function resolveSettings(context: Context): Settings {
  const options = (context.options ?? {}) as Partial<Settings>
  const pick = (value: unknown, fallback: boolean) =>
    typeof value === "boolean" ? value : fallback
  return {
    includeWaiting: pick(options.includeWaiting, DEFAULTS.includeWaiting),
    includeQueued: pick(options.includeQueued, DEFAULTS.includeQueued),
    sound: pick(options.sound, DEFAULTS.sound),
  }
}

function sessionLabel(context: Context, sessionID: string) {
  return context.data.session.get(sessionID)?.title?.trim() || "untitled session"
}

// The target plus every child/subagent session that would be deleted with it.
function treeIDs(context: Context, sessionID: string) {
  return [...new Set([sessionID, ...(context.data.session.family(sessionID) ?? [])])]
}

async function activeReason(context: Context, sessionID: string, settings: Settings) {
  const ids = treeIDs(context, sessionID)
  if (settings.includeWaiting) {
    // Sessions that are not open in a tab may have their permission/question
    // state unsynced, so refresh it before deciding.
    await Promise.all(
      ids.map(async (id) => {
        try {
          await context.data.session.permission.sync(id)
        } catch {}
        try {
          await context.data.session.form?.sync?.(id, context.location)
        } catch {}
      }),
    )
    for (const id of ids) {
      if ((context.data.session.permission.list(id) ?? []).length > 0) return "waiting" as const
      if ((context.data.session.form?.list?.(id, context.location) ?? []).length > 0)
        return "waiting" as const
    }
  }
  for (const id of ids) {
    if (context.data.session.status(id) === "running") return "running" as const
  }
  if (settings.includeQueued) {
    await Promise.all(
      ids.map(async (id) => {
        try {
          await context.data.session.pending?.sync?.(id)
        } catch {}
      }),
    )
    for (const id of ids) {
      if ((context.data.session.pending?.list?.(id) ?? []).length > 0) return "queued" as const
    }
  }
  return undefined
}

const REASONS = {
  running: {
    toast: "is still running",
    detail: "Interrupt it with Esc or wait for it to finish, then delete it.",
    error: "still in progress — interrupt it with Esc or wait, then delete it",
  },
  waiting: {
    toast: "is waiting for an answer",
    detail: "Answer or dismiss the pending permission/question with Esc, then delete it.",
    error: "waiting for an answer — respond or dismiss it with Esc, then delete it",
  },
  queued: {
    toast: "has queued prompts",
    detail: "Remove the queued prompts first, then delete the session.",
    error: "has queued prompts — remove them first, then delete it",
  },
} as const

function block(
  context: Context,
  sessionID: string,
  reason: keyof typeof REASONS,
  settings: Settings,
) {
  const now = Date.now()
  if (now - lastNotify < NOTIFY_INTERVAL) return
  lastNotify = now

  const copy = REASONS[reason]
  const message = `"${sessionLabel(context, sessionID)}" ${copy.toast}. ${copy.detail}`
  context.ui.toast.show({
    title: "Delete blocked",
    message,
    variant: "warning",
    sessionID,
  })
  if (settings.sound) {
    void context.attention.notify({
      message,
      sound: { name: "default", when: "always" },
    })
  }
}

type RemoveInput = { sessionID?: unknown }
type Remove = (input: RemoveInput, options?: unknown) => Promise<unknown>
type PatchedRemove = Remove & { [PATCHED]?: true }

export default Plugin.define({
  id: "session-delete-guard",
  setup(context) {
    const settings = resolveSettings(context)
    const client = context.client as { session?: { remove?: PatchedRemove } } | undefined
    const session = client?.session
    const original = session?.remove

    if (!session || typeof original !== "function") {
      console.error("[session-delete-guard] client.session.remove is unavailable; guard inactive")
      return
    }
    if (original[PATCHED]) return

    const patched: PatchedRemove = async (input, options) => {
      const sessionID = input?.sessionID
      if (typeof sessionID === "string") {
        const reason = await activeReason(context, sessionID, settings)
        if (reason) {
          block(context, sessionID, reason, settings)
          throw new Error(REASONS[reason].error)
        }
      }
      return original.call(session, input, options)
    }
    patched[PATCHED] = true
    session.remove = patched

    return () => {
      if (session.remove === patched) {
        session.remove = original
        delete patched[PATCHED]
      }
    }
  },
})
