import QtQuick
import Quickshell
import Quickshell.Wayland

import "statusline"

Scope {
    PanelWindow {
        id: bar

        anchors { bottom: true; left: true; right: true }
        implicitHeight: 24
        exclusiveZone: 24
        color: Theme.bg

        WlrLayershell.keyboardFocus: State.statusLineMode !== "normal"
            ? KeyboardFocus.Exclusive
            : KeyboardFocus.None

        Keys.onEscapePressed: State.statusLineMode = "normal"

        Row {
            anchors.fill: parent

            Item {
                height: parent.height
                width:  parent.width - rightSection.width

                NormalMode      { anchors.fill: parent; visible: State.statusLineMode === "normal" }
                AppLauncherMode { anchors.fill: parent; visible: State.statusLineMode === "appLauncher" }
                CommandMode     { anchors.fill: parent; visible: State.statusLineMode === "command" }
                WallpapersMode  { anchors.fill: parent; visible: State.statusLineMode === "wallpapers" }
            }

            RightSection {
                id: rightSection
                height: parent.height
            }
        }
    }
}
