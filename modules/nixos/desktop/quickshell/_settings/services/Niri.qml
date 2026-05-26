pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Pure-QML Niri IPC singleton.
// Subscribes to `niri msg --json event-stream` and parses events line-by-line.
// Provides: focusedWindow, workspaces, focusedWorkspaceIndex.
Singleton {
    id: root

    // { id, title, appId, workspaceId, isFloating } or null
    property var focusedWindow: null

    // [{ id, index, name, isActive, isFocused }, ...]
    property var workspaces: []

    // 1-based index of the focused workspace
    readonly property int focusedWorkspaceIndex: {
        for (var i = 0; i < workspaces.length; i++)
            if (workspaces[i].isFocused) return workspaces[i].index + 1
        return 1
    }

    // ── Event stream ──────────────────────────────────────────────────────

    Process {
        id: eventStream
        command: ["niri", "msg", "--json", "event-stream"]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                line = line.trim()
                if (line.length > 0) {
                    try {
                        root._handle(JSON.parse(line))
                    } catch(e) {
                        console.warn("Niri IPC parse error:", e, "| line:", line)
                    }
                }
            }
        }

        onRunningChanged: {
            if (!running) restartTimer.restart()
        }
    }

    Timer {
        id: restartTimer
        interval: 2000; repeat: false
        onTriggered: eventStream.running = true
    }

    // ── Event handler ─────────────────────────────────────────────────────

    function _handle(ev) {

        // ── Workspaces ────────────────────────────────────────────────────

        if (ev.WorkspacesChanged !== undefined) {
            // Full snapshot sent on startup and after layout changes
            workspaces = ev.WorkspacesChanged.workspaces.map(function(w) {
                return {
                    id:        w.id,
                    index:     w.idx,       // 0-based position
                    name:      w.name || "",
                    isActive:  w.is_active,
                    isFocused: w.is_focused
                }
            })
        }

        else if (ev.WorkspaceActivated !== undefined) {
            // A workspace became the active one on its output (not necessarily focused)
            var aId    = ev.WorkspaceActivated.id
            var inMove = ev.WorkspaceActivated.in_moving_monitor
            workspaces = workspaces.map(function(w) {
                return {
                    id:        w.id,
                    index:     w.index,
                    name:      w.name,
                    // Only clear other workspaces' active flag if not a monitor-move operation
                    isActive:  (w.id === aId) ? true : (inMove ? w.isActive : false),
                    isFocused: w.isFocused
                }
            })
        }

        else if (ev.WorkspaceFocused !== undefined) {
            // The keyboard/pointer focus moved to a workspace — this drives the indicator
            var fId = ev.WorkspaceFocused.id
            workspaces = workspaces.map(function(w) {
                return {
                    id:        w.id,
                    index:     w.index,
                    name:      w.name,
                    isActive:  w.isActive,
                    isFocused: w.id === fId
                }
            })
        }

        // ── Windows ───────────────────────────────────────────────────────

        else if (ev.WindowsChanged !== undefined) {
            // Full snapshot — find whichever window is focused
            var focused = null
            var wins = ev.WindowsChanged.windows
            for (var i = 0; i < wins.length; i++) {
                if (wins[i].is_focused) { focused = _mapWindow(wins[i]); break }
            }
            focusedWindow = focused
        }

        else if (ev.WindowFocusChanged !== undefined) {
            // null means no window is focused (e.g. empty workspace)
            var win = ev.WindowFocusChanged.window
            focusedWindow = (win !== null && win !== undefined) ? _mapWindow(win) : null
        }

        else if (ev.WindowOpenedOrChanged !== undefined) {
            var w = ev.WindowOpenedOrChanged.window
            if (w.is_focused) {
                focusedWindow = _mapWindow(w)
            } else if (focusedWindow !== null && focusedWindow.id === w.id) {
                // Title or floating state changed for the window we're already tracking
                focusedWindow = _mapWindow(w)
            }
        }

        else if (ev.WindowClosed !== undefined) {
            if (focusedWindow !== null && focusedWindow.id === ev.WindowClosed.id)
                focusedWindow = null
        }

        // All other events (KeyboardLayoutChanged, OverviewOpenedOrClosed, etc.) ignored
    }

    function _mapWindow(w) {
        return {
            id:          w.id,
            title:       w.title        || "",
            appId:       w.app_id       || "",
            workspaceId: w.workspace_id || null,
            isFloating:  w.is_floating  || false
        }
    }
}
