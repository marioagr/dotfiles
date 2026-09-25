// Session highlights — highlights in orange the sessions whose title starts with
// a status prefix ([PENDIENTE], [TODO], [PENDING], [FIXME], [WIP], ...).
//
// Surfaces:
//   - Counter in the prompt footer (prompt.footer.status); click opens the panel
//   - Full-screen panel via /pending (session.panel)
//
// The native tab strip cannot be recolored from a plugin (TUI API limitation);
// the reorderTabs option (disabled by default) keeps pending sessions at the
// front of the tab strip as an alternative.
import { Plugin } from "@opencode/plugin/tui"
import type { Context, PanelInput } from "@opencode/plugin/tui/context"
import type { SessionInfo } from "@opencode/client"
import type { ScrollBoxRenderable } from "@opentui/core"
import { createEffect, createMemo, createSignal, For, Show } from "solid-js"

const PANEL = "session-highlights.board"
const BOLD = 1

const DEFAULTS = {
  prefixes: ["PENDIENTE", "PENDING", "TODO", "FIXME", "WIP", "EN PROGRESO"],
  color: "#f53003",
  caseSensitive: false,
  maxItems: 8,
  projectOnly: true,
  reorderTabs: false,
}

type Settings = {
  prefixes: string[]
  color: string
  caseSensitive: boolean
  maxItems: number
  projectOnly: boolean
  reorderTabs: boolean
}

function resolveSettings(context: Context): Settings {
  const options = (context.options ?? {}) as Partial<Settings>
  const prefixes =
    Array.isArray(options.prefixes) && options.prefixes.length > 0
      ? options.prefixes
      : DEFAULTS.prefixes
  return {
    prefixes,
    color: typeof options.color === "string" && options.color ? options.color : DEFAULTS.color,
    caseSensitive:
      typeof options.caseSensitive === "boolean" ? options.caseSensitive : DEFAULTS.caseSensitive,
    maxItems:
      typeof options.maxItems === "number" && options.maxItems > 0
        ? Math.floor(options.maxItems)
        : DEFAULTS.maxItems,
    projectOnly:
      typeof options.projectOnly === "boolean" ? options.projectOnly : DEFAULTS.projectOnly,
    reorderTabs:
      typeof options.reorderTabs === "boolean" ? options.reorderTabs : DEFAULTS.reorderTabs,
  }
}

function escapeRe(value: string) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
}

// Matches "[PENDIENTE] ...", "(TODO) ...", "PENDIENTE: ...", "WIP ..." or even
// with emojis in front ("🚧 [TODO] ..."). The \b avoids false positives like
// "TODOLIST".
const matcherCache = new WeakMap<Settings, RegExp>()

function matcher(config: Settings) {
  const cached = matcherCache.get(config)
  if (cached) return cached
  const alternation = config.prefixes
    .map((prefix) => escapeRe(prefix.trim()))
    .filter(Boolean)
    .join("|")
  const regex = new RegExp(
    `^[^A-Za-z0-9]*[\\[({]?\\s*(?:${alternation})\\b`,
    config.caseSensitive ? "" : "i",
  )
  matcherCache.set(config, regex)
  return regex
}

function isPending(config: Settings, title: string | undefined) {
  return typeof title === "string" && matcher(config).test(title)
}

function roots(context: Context, config: Settings) {
  const directory = context.location?.directory
  const sessions = context.data.session.list() ?? []
  return sessions.filter(
    (session) =>
      !session.parentID &&
      !session.time.archived &&
      (!config.projectOnly || !directory || session.location?.directory === directory),
  )
}

function pendingSessions(context: Context, config: Settings) {
  return roots(context, config)
    .filter((session) => isPending(config, session.title))
    .sort((a, b) => b.time.updated - a.time.updated)
}

function orderedSessions(context: Context, config: Settings) {
  return roots(context, config).sort((a, b) => {
    const aPending = isPending(config, a.title) ? 0 : 1
    const bPending = isPending(config, b.title) ? 0 : 1
    if (aPending !== bPending) return aPending - bPending
    return b.time.updated - a.time.updated
  })
}

function sessionLabel(session: SessionInfo) {
  return session.title?.trim() || "(untitled)"
}

function openSession(context: Context, sessionID: string) {
  if (context.ui.tabs.enabled() && context.ui.tabs.focus(sessionID)) return
  context.ui.router.navigate({ type: "session", sessionID })
}

function Counter(props: { context: Context }) {
  const config = resolveSettings(props.context)
  const total = createMemo(() => pendingSessions(props.context, config).length)
  return (
    <Show when={total() > 0}>
      <text
        fg={config.color}
        onMouseUp={() => props.context.ui.panel.open(PANEL)}
      >
        {`${total()} pending`}
      </text>
    </Show>
  )
}

function Board(props: { context: Context; panel: PanelInput }) {
  const context = props.context
  const config = resolveSettings(context)
  const [cursor, setCursor] = createSignal(0)
  let scroll: ScrollBoxRenderable | undefined

  const list = createMemo(() => orderedSessions(context, config))
  const pendingCount = createMemo(
    () => list().filter((session) => isPending(config, session.title)).length,
  )

  createEffect(() => {
    const total = list().length
    setCursor((current) => Math.max(0, Math.min(current, total - 1)))
  })

  const ensureVisible = () => {
    if (!scroll || scroll.isDestroyed) return
    const height = Math.max(1, scroll.viewport.height)
    const total = list().length
    const target = Math.max(
      0,
      Math.min(cursor() - Math.floor(height / 2), Math.max(0, total - height)),
    )
    scroll.scrollTo(target)
  }

  const move = (delta: number) => {
    const total = list().length
    if (total === 0) return
    setCursor((current) => (current + delta + total) % total)
    ensureVisible()
  }

  const open = (index: number) => {
    const session = list()[index]
    if (session) openSession(context, session.id)
  }

  context.keymap.layer(() => ({
    enabled: () => props.panel.focused,
    commands: [
      { bind: "up,k", run: () => move(-1) },
      { bind: "down,j", run: () => move(1) },
      { bind: "home", run: () => setCursor(0) },
      { bind: "end", run: () => setCursor(Math.max(0, list().length - 1)) },
      { bind: "return", run: () => open(cursor()) },
      { bind: "escape", run: () => props.panel.close() },
    ],
  }))

  return (
    <box flexDirection="column" flexGrow={1} minHeight={0} gap={1}>
      <box flexDirection="row" justifyContent="space-between" flexShrink={0}>
        <text fg={context.theme.text.base} attributes={BOLD}>
          {`Pending (${pendingCount()} of ${list().length} ${
            list().length === 1 ? "session" : "sessions"
          })`}
        </text>
        <text fg={context.theme.text.muted}>{"enter open · esc close"}</text>
      </box>
      <Show
        when={list().length > 0}
        fallback={<text fg={context.theme.text.muted}>No sessions with a pending prefix.</text>}
      >
        <scrollbox
          ref={(element: ScrollBoxRenderable) => (scroll = element)}
          flexGrow={1}
          minHeight={0}
        >
          <For each={list()}>
            {(session, index) => {
              const selected = () => index() === cursor()
              const pending = () => isPending(config, session.title)
              const color = () =>
                pending()
                  ? config.color
                  : selected()
                    ? context.theme.text.base
                    : context.theme.text.muted
              return (
                <text
                  fg={color()}
                  attributes={selected() ? BOLD : 0}
                  onMouseUp={() => open(index())}
                >
                  {`${selected() ? "› " : "  "}${sessionLabel(session)}`}
                </text>
              )
            }}
          </For>
        </scrollbox>
      </Show>
    </box>
  )
}

function TabOrder(props: { context: Context }) {
  const config = resolveSettings(props.context)
  let signature = ""
  createEffect(() => {
    const tabs = [...props.context.ui.tabs.list()]
    const pendingIDs = new Set(pendingSessions(props.context, config).map((s) => s.id))
    const desired = [...tabs].sort(
      (a, b) => Number(pendingIDs.has(b.sessionID)) - Number(pendingIDs.has(a.sessionID)),
    )
    const next = desired
      .map((tab) => `${tab.sessionID}${pendingIDs.has(tab.sessionID) ? "!" : ""}`)
      .join("|")
    if (next === signature) return
    signature = next
    desired.forEach((tab, index) => {
      if (tabs[index]?.sessionID !== tab.sessionID) {
        props.context.ui.tabs.move(tab.sessionID, index)
      }
    })
  })
  return null
}

function Commands(props: { context: Context }) {
  const context = props.context
  context.keymap.layer(() => ({
    mode: "global",
    commands: [
      {
        id: "session-highlights.board",
        title: "Pending sessions",
        description: "Shows sessions whose title starts with [PENDIENTE], [TODO], ...",
        group: "Sessions",
        palette: true,
        slash: { name: "pending", aliases: ["pendientes"] },
        enabled: () => context.ui.router.current().type === "session",
        run: () => {
          context.ui.dialog.clear()
          context.ui.panel.open(PANEL)
        },
      },
    ],
  }))
  return null
}

export default Plugin.define({
  id: "session-highlights",
  setup(context) {
    const config = resolveSettings(context)

    context.ui.slot({
      append: "prompt.footer.status",
      render: () => <Counter context={context} />,
    })

    context.ui.slot({
      append: "session.panel",
      render: (panel) => (
        <Show when={panel.name === PANEL}>
          <Board context={context} panel={panel} />
        </Show>
      ),
    })

    if (config.reorderTabs) {
      context.ui.slot({
        append: "app",
        render: () => <TabOrder context={context} />,
      })
    }

    context.ui.slot({
      append: "app",
      render: () => <Commands context={context} />,
    })
  },
})
