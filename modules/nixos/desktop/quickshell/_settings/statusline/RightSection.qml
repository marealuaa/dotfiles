import QtQuick
import Quickshell
import Quickshell.Services.UPower

Row {
    id: root
    spacing: 0

    readonly property var  battery:    UPower.displayDevice
    readonly property bool hasBattery: battery !== null && battery.isPresent

    // ── Left arrow decoration ─────────────────────────────────────────────
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: "\ue0b2"; color: Theme.bg1
        font.family: Theme.font; font.pixelSize: Theme.fontSize
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: "\ue0b3"; color: Theme.gray
        font.family: Theme.font; font.pixelSize: Theme.fontSize
        leftPadding: 4; rightPadding: 4
    }

    // ── Battery ───────────────────────────────────────────────────────────
    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5
        visible: root.hasBattery

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.fg
            font.family: Theme.font; font.pixelSize: Theme.fontSize
            text: {
                if (!root.battery) return ""
                var pct = root.battery.percentage * 100
                var chg = root.battery.state === UPowerDeviceState.Charging
                if (chg) {
                    if (pct < 10) return "\udb80\udc9c"
                    if (pct < 20) return "\udb80\udc86"
                    if (pct < 30) return "\udb80\udc87"
                    if (pct < 40) return "\udb80\udc88"
                    if (pct < 60) return "\udb80\udc9d"
                    if (pct < 80) return "\udb80\udc89"
                    if (pct < 90) return "\udb80\udc8b"
                    return "\udb80\udc85"
                } else {
                    if (pct < 5)  return "\udb80\udc8e"
                    if (pct < 20) return "\udb80\udc7b"
                    if (pct < 40) return "\udb80\udc7d"
                    if (pct < 60) return "\udb80\udc7f"
                    if (pct < 80) return "\udb80\udc81"
                    if (pct < 90) return "\udb80\udc82"
                    return "\udb80\udc79"
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.battery ? Math.floor(root.battery.percentage * 100) + "%" : ""
            color: Theme.fg
            font.family: Theme.font; font.pixelSize: Theme.fontSize
        }
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        visible: root.hasBattery
        text: "\ue0b3"; color: Theme.gray
        font.family: Theme.font; font.pixelSize: Theme.fontSize
        leftPadding: 4; rightPadding: 4
    }

    // ── Username ──────────────────────────────────────────────────────────
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: SysInfo.user; color: Theme.fg
        font.family: Theme.font; font.pixelSize: Theme.fontSize
        leftPadding: 2; rightPadding: 6
    }

    // ── Clock ─────────────────────────────────────────────────────────────
    Rectangle {
        height: parent.height
        width:  clockText.implicitWidth + 32
        color:  Theme.bg1

        Text {
            id: clockText
            anchors.centerIn: parent
            color: Theme.primary
            font.family: Theme.font; font.pixelSize: Theme.fontSize
            text: Qt.formatDateTime(new Date(), "hh:mm AP")

            SystemClock {
                precision: SystemClock.Seconds
                onDateChanged: clockText.text = Qt.formatDateTime(date, "hh:mm AP")
            }
        }
    }

    // ── Niri workspace index ──────────────────────────────────────────────
    Rectangle {
        height: parent.height
        width:  wsText.implicitWidth + 32
        color:  Theme.primary

        Text {
            id: wsText
            anchors.centerIn: parent
            color: Theme.bg
            font.family: Theme.font; font.pixelSize: Theme.fontSize
            font.weight: Font.Bold
            text: Niri.focusedWorkspaceIndex.toString()
        }
    }
}
