import QtQuick
import QtQuick.Controls

Row {
    id: root
    property int    depth: 0
    property string icon:  ""
    property string label: ""
    property real   value: 0.5
    property real   from:  0.0
    property real   to:    1.0

    signal moved(real val)

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
    Slider {
        id: sl
        anchors.verticalCenter: parent.verticalCenter
        from: root.from; to: root.to
        value: root.value
        implicitWidth: 80; implicitHeight: 14
        onMoved: root.moved(sl.value)

        handle: Rectangle {
            x: sl.leftPadding + sl.visualPosition * (sl.availableWidth - width)
            y: sl.topPadding + sl.availableHeight / 2 - height / 2
            width: 8; height: 8; radius: 4
            color: Theme.fg
        }
        background: Rectangle {
            x: sl.leftPadding
            y: sl.topPadding + sl.availableHeight / 2 - height / 2
            width: sl.availableWidth; height: 10
            color: Theme.bg2; radius: 2
            Rectangle {
                width: sl.visualPosition * parent.width
                height: parent.height
                color: Theme.secondary; radius: 2
            }
        }
    }
}
