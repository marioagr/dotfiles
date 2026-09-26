// exit-guard — prevents leaving OpenCode with Ctrl+C/Ctrl+D while work is active
// and prevents those keys from dismissing pending questions or permissions.
//
// Rules:
//   - Pending question (form) or permission in the visible session -> blocks with
//     a notice. Esc remains the deliberate way to dismiss/reject.
//   - Any running session or one waiting for an answer -> blocks exit.
//   - Textarea with text (prompt, form answer, rejection reason) -> falls through:
//     Ctrl+C clears and Ctrl+D deletes as usual.
//   - modal/menu/composer/autocomplete modes and the diff viewer -> falls through;
//     those layers already handle the key.
//   - No active work -> falls through and app.exit exits normally.
//   - <leader>q is untouched: it remains the deliberate exit.
import { Plugin } from "@opencode/plugin/tui"
import type { Context } from "@opencode/plugin/tui/context"
import type { SessionInfo } from "@opencode/client"

const BIND = "ctrl+c,ctrl+d"
const NOTIFY_INTERVAL = 1500
// Above the form layers (navigation 0, editing 1); below the sidebar close (10)
// and the copy interceptors (100/101).
const PRIORITY = 2

// Avoids spamming toast/sound when the key is mashed.
let lastNotify = 0

type Work = {
  running: SessionInfo[]
  waiting: SessionInfo[]
}

function sessionLabel(session: SessionInfo) {
  return session.title?.trim() || "untitled session"
}

function currentSessionID(context: Context) {
  const route = context.ui.router.current()
  return route.type === "session" ? route.sessionID : undefined
}

// Walks every session (including children/subagents) and separates the running
// ones from those waiting for an answer (permission or form).
function collectWork(context: Context): Work {
  const running: SessionInfo[] = []
  const waiting: SessionInfo[] = []
  for (const session of context.data.session.list() ?? []) {
    if (session.time.archived) continue
    if (context.data.session.status(session.id) === "running") {
      running.push(session)
      continue
    }
    const permissions = context.data.session.permission.list(session.id) ?? []
    const forms = context.data.session.form?.list?.(session.id, context.location) ?? []
    if (permissions.length > 0 || forms.length > 0) waiting.push(session)
  }
  return { running, waiting }
}

function currentForm(context: Context) {
  const sessionID = currentSessionID(context)
  if (!sessionID) return false
  const forms = context.data.session.form?.list?.(sessionID, context.location) ?? []
  return forms.length > 0
}

function currentPermission(context: Context) {
  const sessionID = currentSessionID(context)
  if (!sessionID) return false
  const permissions = context.data.session.permission.list(sessionID) ?? []
  return permissions.length > 0
}

// The diff viewer binds Ctrl+C to "close viewer"; do not step on it.
function diffViewerOpen(context: Context) {
  return context.keymap.commands().some((command) => command.id === "diff.close")
}

// Textareas (prompt, answers) use their own keys; single-line inputs (rename,
// dialog prompts) do not. maxLength only exists on InputRenderable, so it
// distinguishes them without importing OpenTUI.
function isTextarea(editor: { maxLength?: unknown }) {
  return !("maxLength" in editor)
}

function describe(work: Work) {
  const total = work.running.length + work.waiting.length
  const first = work.running[0] ?? work.waiting[0]
  if (total === 1) {
    return work.running.length === 1
      ? `"${sessionLabel(first)}" is running`
      : `"${sessionLabel(first)}" is waiting for an answer`
  }
  const parts: string[] = []
  if (work.running.length > 0) parts.push(`${work.running.length} running`)
  if (work.waiting.length > 0) parts.push(`${work.waiting.length} waiting for an answer`)
  return `${total} active sessions (${parts.join(", ")})`
}

function notify(context: Context, message: string, sessionID?: string) {
  const now = Date.now()
  if (now - lastNotify < NOTIFY_INTERVAL) return
  lastNotify = now
  context.ui.toast.show({
    title: "Exit blocked",
    message,
    variant: "warning",
    sessionID,
  })
  void context.attention.notify({
    message,
    sound: { name: "default", when: "always" },
  })
}

function Guard(props: { context: Context }) {
  const context = props.context
  context.keymap.layer(() => ({
    mode: "global",
    priority: PRIORITY,
    commands: [
      {
        id: "exit-guard.attempt",
        bind: BIND,
        title: "Exit (guarded)",
        description: "Exits only when there are no active sessions or pending questions",
        group: "System",
        run: () => {
          // Dialogs, menus, composer and autocomplete have their own layers.
          const mode = context.keymap.mode.current()
          if (mode !== "base" && mode !== "form") return false
          if (mode === "base" && diffViewerOpen(context)) return false

          const editor = context.renderer.currentFocusedEditor
          if (editor && !editor.isDestroyed && isTextarea(editor) && editor.plainText !== "") {
            return false
          }

          const sessionID = currentSessionID(context)
          if (currentForm(context)) {
            notify(
              context,
              "There is a pending question: answer it or dismiss it with Esc.",
              sessionID,
            )
            return
          }
          if (currentPermission(context)) {
            notify(
              context,
              "There is a pending permission: accept or reject it with Esc.",
              sessionID,
            )
            return
          }

          const work = collectWork(context)
          if (work.running.length === 0 && work.waiting.length === 0) return false
          notify(
            context,
            `Cannot exit: ${describe(work)}. Interrupt with Esc or respond; <leader>q still exits.`,
            (work.running[0] ?? work.waiting[0]).id,
          )
        },
      },
    ],
  }))
  return null
}

export default Plugin.define({
  id: "exit-guard",
  setup(context) {
    context.ui.slot({
      append: "app",
      render: () => <Guard context={context} />,
    })
  },
})
