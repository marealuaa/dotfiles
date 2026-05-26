pragma Singleton
import Quickshell

Singleton {
    // "normal" | "appLauncher" | "command" | "wallpapers"
    property string statusLineMode: "normal"
    property bool   fileExplorerVisible: false
    property bool   wallpaperWindowVisible: false

    function toggleMode(mode) {
        statusLineMode = (statusLineMode === mode) ? "normal" : mode
    }
}
