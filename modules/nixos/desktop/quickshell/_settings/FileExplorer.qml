import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

import "fileexplorer"

Scope {
    PanelWindow {
        id: panel

        anchors {
            top: true
            bottom: true
            left: true
        }

        implicitWidth: State.fileExplorerVisible ? 230 : 0
        exclusiveZone: State.fileExplorerVisible ? 230 : 0
        color: "transparent"

        Behavior on implicitWidth {
            NumberAnimation {
                duration: Theme.animSpeed
                easing.type: Easing.OutCubic
            }
        }

        // ── Panel body ────────────────────────────────────────────────────
        Rectangle {
            width: 230
            height: parent.height
            color: Theme.bg
            clip: true

            // Right border
            Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

                width: 2
                color: Theme.border
            }

            Column {
                anchors.fill: parent
                spacing: 0

                // Header
                Rectangle {
                    width: parent.width
                    height: 22
                    color: Theme.bg2

                    Text {
                        anchors.centerIn: parent
                        text: "  file_explorer"
                        color: Theme.fg
                        font.family: Theme.font
                        font.pixelSize: Theme.fontSize
                    }
                }

                // Path hint
                Text {
                    width: parent.width
                    leftPadding: 6

                    text: "~/.config/ags/windows/file_explorer"

                    color: Theme.yellow
                    font.family: Theme.font
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    elide: Text.ElideRight
                }

                // Scrollable tree
                Flickable {
                    width: parent.width
                    height: parent.height - 44
                    contentHeight: tree.implicitHeight
                    clip: true

                    Column {
                        id: tree
                        width: parent.width

                        // ── fetch/ ────────────────────────────────────────
                        TreeRow {
                            depth: 0
                            icon: ""
                            label: "fetch"
                            isDir: true
                            labelColor: Theme.blue
                        }

                        ValueRow {
                            depth: 1
                            icon: "\udb80\udcc2"
                            label: "device"
                            value: SysInfo.device
                        }

                        ValueRow {
                            depth: 1
                            icon: ""
                            label: "cpu"
                            value: SysInfo.cpu
                        }

                        ValueRow {
                            depth: 1
                            icon: "\udb81\udc06"
                            label: "gpu"
                            value: SysInfo.gpu
                        }

                        ValueRow {
                            depth: 1
                            icon: ""
                            label: "user"
                            value: SysInfo.user
                        }

                        ValueRow {
                            depth: 1
                            icon: "\udb82\uddcf"
                            label: "pkgs"
                            value: SysInfo.pkgs
                        }

                        ValueRow {
                            depth: 1
                            icon: "\udb84\uddc6"
                            label: "uptime"
                            value: SysInfo.uptime
                        }

                        // ── stats/ ────────────────────────────────────────
                        TreeRow {
                            depth: 0
                            icon: ""
                            label: "stats"
                            isDir: true
                            labelColor: Theme.blue
                        }

                        BarRow {
                            depth: 1
                            icon: ""
                            label: "cpu"
                            value: SysInfo.cpuLoad
                        }

                        BarRow {
                            depth: 1
                            icon: ""
                            label: "ram"
                            value: SysInfo.ramLoad
                        }
                    }
                }
            }
        }

        Process {
            id: volProc
            command: [
                "bash",
                "-c",
                "wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%"
            ]
        }
    }
}
