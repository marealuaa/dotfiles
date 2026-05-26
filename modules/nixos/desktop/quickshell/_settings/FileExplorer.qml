import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

import "fileexplorer"

Scope {
    PanelWindow {
        id: panel

        anchors { top: true; bottom: true; left: true }
        // Width drives the slide — exclusionZone matches statically to avoid reflow jank
        implicitWidth:  State.fileExplorerVisible ? 230 : 0
        exclusionZone:  State.fileExplorerVisible ? 230 : 0
        color: "transparent"

        Behavior on implicitWidth {
            NumberAnimation { duration: Theme.animSpeed; easing.type: Easing.OutCubic }
        }

        clip: true

        // ── Panel body ────────────────────────────────────────────────────
        Rectangle {
            width: 230; height: parent.height
            color: Theme.bg

            // Right border
            Rectangle {
                anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
                width: 2; color: Theme.border
            }

            Column {
                anchors.fill: parent
                spacing: 0

                // Header
                Rectangle {
                    width: parent.width; height: 22
                    color: Theme.bg2
                    Text {
                        anchors.centerIn: parent
                        text: "  file_explorer"
                        color: Theme.fg
                        font.family: Theme.font; font.pixelSize: Theme.fontSize
                    }
                }

                // Path hint
                Text {
                    width: parent.width; leftPadding: 6
                    text: "~/.config/ags/windows/file_explorer"
                    color: Theme.yellow
                    font.family: Theme.font; font.pixelSize: 11
                    font.weight: Font.Bold; elide: Text.ElideRight
                }

                // Scrollable tree
                Flickable {
                    width:  parent.width
                    height: parent.height - 44
                    contentHeight: tree.implicitHeight
                    clip: true

                    Column {
                        id: tree
                        width: parent.width

                        // ── fetch/ ────────────────────────────────────────
                        TreeRow  { depth: 0; icon: ""; label: "fetch"; isDir: true; labelColor: Theme.blue }
                        ValueRow { depth: 1; icon: "\udb80\udcc2"; label: "device"; value: SysInfo.device }
                        ValueRow { depth: 1; icon: "";             label: "cpu";    value: SysInfo.cpu }
                        ValueRow { depth: 1; icon: "\udb81\udc06"; label: "gpu";    value: SysInfo.gpu }
                        ValueRow { depth: 1; icon: "";             label: "user";   value: SysInfo.user }
                        ValueRow { depth: 1; icon: "\udb82\uddcf"; label: "pkgs";   value: SysInfo.pkgs }
                        ValueRow { depth: 1; icon: "\udb84\uddc6"; label: "uptime"; value: SysInfo.uptime }

                        // ── stats/ ────────────────────────────────────────
                        TreeRow { depth: 0; icon: ""; label: "stats"; isDir: true; labelColor: Theme.blue }
                        BarRow  { depth: 1; icon: ""; label: "cpu"; value: SysInfo.cpuLoad }
                        BarRow  { depth: 1; icon: ""; label: "ram"; value: SysInfo.ramLoad }

                        TreeRow { depth: 1; icon: "\udb82\uddc9"; label: "disks"; isDir: true; labelColor: Theme.blue }
                        Repeater {
                            model: SysInfo.disks
                            BarRow {
                                depth: 2; icon: "\udb82\uddc9"
                                label: modelData.partition
                                value: modelData.usedPct
                                hint:  modelData.used + "/" + modelData.size
                            }
                        }

                        // ── desktop/ ─────────────────────────────────────
                        TreeRow { depth: 0; icon: ""; label: "desktop"; isDir: true; labelColor: Theme.blue }

                        // music_player/
                        TreeRow  { depth: 1; icon: "\udb82\udc79"; label: "music_player"; isDir: true; labelColor: Theme.blue }
                        ValueRow { depth: 2; icon: "\udb82\udc81"; label: "title";  value: MediaPlayer.trackTitle }
                        ValueRow { depth: 2; icon: "\udb82\udd03"; label: "artist"; value: MediaPlayer.trackArtist }
                        ValueRow { depth: 2; icon: "\udb80\udc45"; label: "album";  value: MediaPlayer.trackAlbum }

                        // Controls row (prev / play-pause / next)
                        Row {
                            height: 24; width: parent.width
                            leftPadding: 6 + 2 * 14; spacing: 0

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: " "; color: Theme.gray
                                font.family: Theme.font; font.pixelSize: 12
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: " controls \u2192 "
                                color: Theme.fg; font.family: Theme.font; font.pixelSize: 12
                            }
                            Row {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 12

                                Text {
                                    text: "\udb81\udcae"
                                    color: MediaPlayer.available ? Theme.fg : Theme.gray
                                    font.family: Theme.font; font.pixelSize: 18
                                    anchors.verticalCenter: parent.verticalCenter
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: MediaPlayer.previous() }
                                }
                                Text {
                                    text: MediaPlayer.isPlaying ? "\udb80\udf64" : "\udb80\udc0a"
                                    color: MediaPlayer.available ? Theme.fg : Theme.gray
                                    font.family: Theme.font; font.pixelSize: 18
                                    anchors.verticalCenter: parent.verticalCenter
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: MediaPlayer.togglePlay() }
                                }
                                Text {
                                    text: "\udb81\udcad"
                                    color: MediaPlayer.available ? Theme.fg : Theme.gray
                                    font.family: Theme.font; font.pixelSize: 18
                                    anchors.verticalCenter: parent.verticalCenter
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: MediaPlayer.next() }
                                }
                            }
                        }

                        // desktop_controls/
                        TreeRow { depth: 1; icon: "\udb80\udffe"; label: "desktop_controls"; isDir: true; labelColor: Theme.blue }

                        SliderRow {
                            depth: 2; icon: "\udb81\udd3e"; label: "speaker"
                            from: 0; to: 1.5; value: 0.5
                            onMoved: function(v) {
                                volProc.command = ["bash", "-c",
                                    "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + Math.round(v * 100) + "%"]
                                volProc.running = true
                            }
                        }
                        SliderRow {
                            depth: 2; icon: "\udb81\udd1a"; label: MediaPlayer.playerName.toLowerCase()
                            from: 0; to: 1
                            value: MediaPlayer.available ? MediaPlayer.volume : 0.5
                            onMoved: function(v) {
                                if (MediaPlayer.available) MediaPlayer.setVolume(v)
                            }
                        }
                        SliderRow {
                            depth: 2; icon: "\udb80\udce0"; label: "bright"
                            from: 0; to: 1
                            value: Brightness.brightness
                            onMoved: function(v) { Brightness.setBrightness(v) }
                        }

                        // wallpapers/ — opens the wallpaper grid
                        TreeRow { depth: 0; icon: ""; label: "wallpapers"; isDir: true; labelColor: Theme.blue }

                        Row {
                            height: 20; width: parent.width
                            leftPadding: 6 + 1 * 14; spacing: 0

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: " "
                                color: Theme.gray; font.family: Theme.font; font.pixelSize: 12
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: " open_picker \u2192 "
                                color: Theme.fg; font.family: Theme.font; font.pixelSize: 12
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "[enter]"
                                color: Theme.primary; font.family: Theme.font; font.pixelSize: 12
                                font.weight: Font.Bold
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: State.wallpaperWindowVisible = true
                                }
                            }
                        }

                        // notifications/
                        TreeRow { depth: 0; icon: ""; label: "notifications"; isDir: true; labelColor: Theme.blue }

                        NotificationServer { id: notifServer }

                        Repeater {
                            model: {
                                var grouped = {}
                                var notifs = notifServer.trackedNotifications
                                for (var i = 0; i < notifs.length; i++) {
                                    var app = notifs[i].appName || "unknown"
                                    if (!grouped[app]) grouped[app] = []
                                    grouped[app].push(notifs[i])
                                }
                                var result = []
                                for (var key in grouped)
                                    result.push({ app: key, notifs: grouped[key] })
                                return result
                            }

                            Column {
                                width: parent.width

                                TreeRow {
                                    depth: 1; icon: ""; isDir: true
                                    label: modelData.app; labelColor: Theme.blue
                                }

                                Repeater {
                                    model: modelData.notifs
                                    Row {
                                        height: 18; width: parent.width
                                        leftPadding: 6 + 2 * 14

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: " "; color: Theme.gray
                                            font.family: Theme.font; font.pixelSize: 12
                                        }
                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: modelData.summary || "(no summary)"
                                            color: Theme.fg; font.family: Theme.font; font.pixelSize: 12
                                            elide: Text.ElideRight; width: 170
                                        }
                                    }
                                }
                            }
                        }

                    } // Column (tree)
                } // Flickable
            } // Column
        } // Rectangle

        // wpctl process (must be child of the PanelWindow scope)
        Process {
            id: volProc
            command: ["bash", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%"]
        }

    } // PanelWindow
}
