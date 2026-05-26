import QtQuick
import QtQuick.Controls

Row {
    id: root
    property int    depth: 0
    property string icon:  ""
    property string label: ""
    property real   value: 0.0   // 0.0 – 1.0
    property string hint:  ""    // optional text after bar

    height: 20
    width:  parent ? parent.width : 220
    spacing: 0
    leftPadding: 6 + depth * 14

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: " "
        color: Theme.gray; font.family: Theme.font; font.pixelSize: 12
    }
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: (root.icon !== "" ? root.icon + " " : "") + root.label + " → "
        color: Theme.fg; font.family: Theme.font; font.pixelSize: 12
    }
    ProgressBar {
        anchors.verticalCenter: parent.verticalCenter
        from: 0; to: 1; value: root.value
        implicitWidth: 72; implicitHeight: 10

        background: Rectangle {
            implicitWidth: 72; implicitHeight: 10
            color: Theme.bg2; radius: 2
        }
        contentItem: Item {
            Rectangle {
                width: parent.parent.visualPosition * parent.width
                height: parent.height
                color: Theme.secondary; radius: 2
            }
        }
    }
    Text {
        anchors.verticalCenter: parent.verticalCenter
        visible: root.hint !== ""
        text: "  " + root.hint
        color: Theme.fg2; font.family: Theme.font; font.pixelSize: 11
    }
}
