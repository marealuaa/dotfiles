import QtQuick
import Quickshell

Item {
    id: root

    readonly property var    focusedWin: Niri.focusedWindow
    readonly property bool   isFloating: focusedWin !== null && focusedWin.isFloating
    readonly property string winTitle:   focusedWin !== null ? (focusedWin.title || "~") : "~"

    Row {
        anchors.fill: parent
        spacing: 0

        // ── Tiling / Floating badge ───────────────────────────────────────
        Rectangle {
            height: parent.height
            width:  modeLabel.implicitWidth + 32
            color:  root.isFloating ? Theme.secondary : Theme.primary

            Text {
                id: modeLabel
                anchors.centerIn: parent
                text:  root.isFloating ? "FLOATING" : "TILING"
                color: Theme.bg
                font.family:    Theme.font
                font.pixelSize: Theme.fontSize
                font.weight:    Font.Bold
            }
        }

        Item { width: 8; height: parent.height }

        // ── Active window title ───────────────────────────────────────────
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text:  root.winTitle
            color: Theme.fg
            font.family:    Theme.font
            font.pixelSize: Theme.fontSize
            elide: Text.ElideRight
            width: Math.min(implicitWidth, 400)
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text:  "  [+]"
            color: Theme.fg2
            font.family:    Theme.font
            font.pixelSize: Theme.fontSize
        }

        // ── Divider ───────────────────────────────────────────────────────
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text:  "  \ue0b1  "
            color: Theme.gray
            font.family:    Theme.font
            font.pixelSize: Theme.fontSize
        }

        // ── Media player indicator ────────────────────────────────────────
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.fg
            font.family:    Theme.font
            font.pixelSize: Theme.fontSize
            text: MediaPlayer.available
                ? "\udb81\udd1a  " + MediaPlayer.trackTitle + " - " + MediaPlayer.trackArtist
                : "\udb81\udd1b  No Music"
        }
    }
}
