// Server entrypoint (no-op) for the session-highlights plugin.
// The UI lives in tui.tsx; this file exists so the plugin has the complete
// layout of a package and the server discovers it with the TUI feature.
// Like env-protection.js, we export the object directly because local plugins
// cannot resolve "@opencode/plugin" at runtime.
export default {
  id: "session-highlights",
  setup() {},
}
