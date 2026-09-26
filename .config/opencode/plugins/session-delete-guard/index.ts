// Server entrypoint (no-op) for the session-delete-guard plugin.
// The guard lives in the CLI runtime (tui.tsx); this file keeps the local
// package layout, same as exit-guard and session-highlights.
export default {
  id: "session-delete-guard",
  setup() {},
}
