import QtQuick
import Quickshell
import Quickshell.Io

Item {
    anchors.fill: parent

    readonly property var commands: [
        { displayName: "shutdown",  cmd: ["systemctl", "poweroff"] },
        { displayName: "restart",   cmd: ["systemctl", "reboot"] },
        { displayName: "suspend",   cmd: ["bash", "-c", "systemctl suspend"] },
        { displayName: "logout",    cmd: ["niri", "msg", "action", "quit"] },
    ]

    Process { id: execProc; command: ["true"] }

    MenuMode {
        anchors.fill: parent
        items: parent.commands
        onActivate: function(item) {
            execProc.command = item.cmd
            execProc.running = true
        }
    }
}
