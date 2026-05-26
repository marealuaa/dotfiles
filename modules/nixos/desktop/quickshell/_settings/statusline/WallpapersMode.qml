import QtQuick
import Quickshell
import Quickshell.Io

// Quick wallpaper picker in the statusbar.
// Uses the Wallpaper singleton — no swww needed.
Item {
    anchors.fill: parent

    property var wallpaperItems: []

    Process {
        id: findProc
        command: ["bash", "-c",
            "find -L \"$HOME/.config/wallpapers\" -type f " +
            "\\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) " +
            "2>/dev/null | sort"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = this.text.trim().split('\n').filter(function(l) { return l.length > 0 })
                parent.wallpaperItems = lines.map(function(path) {
                    var parts = path.split('/')
                    return { displayName: parts[parts.length - 1], path: path }
                })
            }
        }
    }

    MenuMode {
        anchors.fill: parent
        items: parent.wallpaperItems
        onActivate: function(item) {
            Wallpaper.setWallpaper(item.path)
        }
    }
}
