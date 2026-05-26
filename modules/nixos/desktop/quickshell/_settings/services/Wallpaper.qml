pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Manages the active wallpaper path.
// Persists the selection to ~/.local/share/quickshell/vim-styled/wallpaper
// so it survives restarts.
Singleton {
    id: root

    property string path: ""

    // Use XDG_DATA_HOME or default
    readonly property string _stateDir:  (StandardPaths.writableLocation(StandardPaths.AppDataLocation))
    readonly property string _stateFile: _stateDir + "/wallpaper"

    // ── Read persisted path on startup ────────────────────────────────────
    Process {
        id: readProc
        command: ["bash", "-c", "cat \"$XDG_DATA_HOME/quickshell/vim-styled/wallpaper\" 2>/dev/null || true"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var p = this.text.trim()
                if (p.length > 0) root.path = p
            }
        }
    }

    // ── Persist on change ─────────────────────────────────────────────────
    Process {
        id: writeProc
        command: ["bash", "-c", "true"]
    }

    onPathChanged: {
        if (path.length === 0) return
        writeProc.command = [
            "bash", "-c",
            "mkdir -p \"$XDG_DATA_HOME/quickshell/vim-styled\" && " +
            "printf '%s' " + JSON.stringify(path) + " > \"$XDG_DATA_HOME/quickshell/vim-styled/wallpaper\""
        ]
        writeProc.running = true
    }

    function setWallpaper(newPath) {
        root.path = newPath
    }
}
