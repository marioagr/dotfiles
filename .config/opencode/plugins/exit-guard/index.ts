// Server entrypoint (no-op) for the exit-guard plugin.
// The UI and the keymap layer live in tui.tsx; this file exists so the plugin
// has the complete layout of a local package, same as session-highlights.
export default {
  id: "exit-guard",
  setup() {},
}
