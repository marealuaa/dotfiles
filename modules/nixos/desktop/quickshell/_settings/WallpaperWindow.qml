import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

// Full-screen wallpaper picker overlay.
// Applies wallpaper natively via the Wallpaper singleton (WlrLayer.Background).
// No swww or any external tool required.
Scope {
    PanelWindow {
        id: wpWindow
        visible: State.wallpaperWindowVisible

        anchors { top: true; bottom: true; left: true; right: true }
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: State.wallpaperWindowVisible
            ? KeyboardFocus.Exclusive
            : KeyboardFocus.None

        Keys.onEscapePressed: State.wallpaperWindowVisible = false

        // ── State ─────────────────────────────────────────────────────────
        property var allWallpapers:      []
        property var filteredWallpapers: []

        function filterWallpapers(q) {
            var ql = q.toLowerCase()
            filteredWallpapers = (ql === "")
                ? allWallpapers
                : allWallpapers.filter(function(w) {
                    return w.name.toLowerCase().includes(ql)
                  })
        }

        // ── Discover wallpapers ───────────────────────────────────────────
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
                    wpWindow.allWallpapers = lines.map(function(path) {
                        var parts = path.split('/')
                        return { name: parts[parts.length - 1], path: path }
                    })
                    wpWindow.filterWallpapers(searchField.text)
                }
            }
        }

        onVisibleChanged: {
            if (visible) {
                searchField.text = ""
                filterWallpapers("")
                findProc.running = true
                searchField.forceActiveFocus()
            }
        }

        // ── Background scrim ──────────────────────────────────────────────
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0.094, 0.086, 0.086, 0.88)
            MouseArea {
                anchors.fill: parent
                onClicked: State.wallpaperWindowVisible = false
            }
        }

        // ── Main panel ────────────────────────────────────────────────────
        Rectangle {
            anchors.centerIn: parent
            width:  Math.min(parent.width  * 0.85, 1100)
            height: Math.min(parent.height * 0.85, 740)
            color:  Theme.bg1
            radius: 4

            // Absorb clicks so scrim doesn't trigger
            MouseArea { anchors.fill: parent; onClicked: {} }

            // Border
            Rectangle {
                anchors.fill: parent; color: "transparent"
                border.color: Theme.border; border.width: 2; radius: 4
            }

            Column {
                anchors.fill: parent; spacing: 0

                // ── Header ────────────────────────────────────────────────
                Rectangle {
                    width: parent.width; height: 36
                    color: Theme.bg2; radius: 4

                    // Fill bottom corners
                    Rectangle {
                        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                        height: 4; color: Theme.bg2
                    }

                    Row {
                        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
                        spacing: 0

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "\udb80\udcf3  wallpapers"
                            color: Theme.primary
                            font.family: Theme.font; font.pixelSize: Theme.fontSize
                            font.weight: Font.Bold
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "  \ue0b1  "; color: Theme.gray
                            font.family: Theme.font; font.pixelSize: Theme.fontSize
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: ":"; color: Theme.primary
                            font.family: Theme.font; font.pixelSize: Theme.fontSize
                        }
                        TextField {
                            id: searchField
                            anchors.verticalCenter: parent.verticalCenter
                            width: 240; background: null
                            color: Theme.fg
                            font.family: Theme.font; font.pixelSize: Theme.fontSize
                            leftPadding: 4
                            placeholderText: "filter..."
                            placeholderTextColor: Theme.gray
                            onTextChanged: wpWindow.filterWallpapers(text)
                            Keys.onEscapePressed: State.wallpaperWindowVisible = false
                        }
                        // Spacer
                        Item { width: 1; height: 1
                            Component.onCompleted: {
                                // stretch — can't use Layout.fillWidth in Row, so just pad
                            }
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: wpWindow.filteredWallpapers.length + " images  \ue0b3  [ESC]"
                            color: Theme.gray
                            font.family: Theme.font; font.pixelSize: 12
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: State.wallpaperWindowVisible = false
                            }
                        }
                    }
                }

                // ── Thumbnail grid ────────────────────────────────────────
                ScrollView {
                    width: parent.width
                    height: parent.height - 36 - 28
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                    GridView {
                        id: grid
                        anchors { fill: parent; margins: 10 }

                        readonly property int cols: Math.max(1, Math.floor(width / 185))
                        cellWidth:  Math.floor(width / cols)
                        cellHeight: Math.floor(cellWidth * 0.58) + 28

                        model: wpWindow.filteredWallpapers

                        delegate: Item {
                            width:  grid.cellWidth
                            height: grid.cellHeight

                            readonly property bool isCurrent: modelData.path === Wallpaper.path

                            Rectangle {
                                anchors { fill: parent; margins: 5 }
                                color:        isCurrent ? Theme.primary : Theme.bg2
                                border.color: isCurrent ? Theme.primary : Theme.border
                                border.width: isCurrent ? 2 : 1
                                radius: 3

                                Column {
                                    anchors.fill: parent; spacing: 0

                                    // Thumbnail
                                    Item {
                                        width:  parent.width
                                        height: parent.height - 28

                                        Image {
                                            anchors.fill: parent
                                            source:   "file://" + modelData.path
                                            fillMode: Image.PreserveAspectCrop
                                            clip:     true
                                            smooth:   true
                                            asynchronous: true

                                            // Loading placeholder
                                            Rectangle {
                                                anchors.fill: parent
                                                color: Theme.bg2
                                                visible: parent.status !== Image.Ready
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "\udb80\udcf3"
                                                    color: Theme.gray
                                                    font.family: Theme.font; font.pixelSize: 28
                                                }
                                            }
                                        }

                                        // "active" badge
                                        Rectangle {
                                            visible: isCurrent
                                            anchors { top: parent.top; right: parent.right; margins: 4 }
                                            width:  badge.implicitWidth + 8; height: 16
                                            color: Theme.secondary; radius: 2
                                            Text {
                                                id: badge
                                                anchors.centerIn: parent
                                                text: " active"
                                                color: Theme.bg
                                                font.family: Theme.font; font.pixelSize: 10
                                                font.weight: Font.Bold
                                            }
                                        }
                                    }

                                    // Filename
                                    Text {
                                        width: parent.width; height: 28
                                        leftPadding: 6
                                        verticalAlignment: Text.AlignVCenter
                                        text:  modelData.name
                                        color: isCurrent ? Theme.bg : Theme.fg
                                        font.family: Theme.font; font.pixelSize: 11
                                        elide: Text.ElideRight
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        Wallpaper.setWallpaper(modelData.path)
                                        State.wallpaperWindowVisible = false
                                    }
                                }
                            }
                        }
                    }
                }

                // ── Footer ────────────────────────────────────────────────
                Rectangle {
                    width: parent.width; height: 28
                    color: Theme.bg2; radius: 4

                    Rectangle {
                        anchors { left: parent.left; right: parent.right; top: parent.top }
                        height: 4; color: Theme.bg2
                    }

                    Row {
                        anchors { fill: parent; leftMargin: 12 }; spacing: 6

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "\udb80\udcf3"; color: Theme.primary
                            font.family: Theme.font; font.pixelSize: 13
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: Wallpaper.path !== "" ? Wallpaper.path : "no wallpaper set"
                            color: Theme.fg2
                            font.family: Theme.font; font.pixelSize: 12
                            elide: Text.ElideLeft
                            width: parent.width - 40
                        }
                    }
                }
            }
        }
    }
}
