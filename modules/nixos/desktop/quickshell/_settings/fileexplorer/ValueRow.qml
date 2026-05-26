import QtQuick

Row {
    id: root
    property int    depth: 0
    property string icon:  ""
    property string label: ""
    property string value: ""

    height: 20
    width:  parent ? parent.width : 220
    spacing: 0
    leftPadding: 6 + depth * 14

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: " "
        color: Theme.gray
        font.family: Theme.font; font.pixelSize: 12
    }
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: (root.icon !== "" ? root.icon + " " : "") + root.label + " → "
        color: Theme.fg
        font.family: Theme.font; font.pixelSize: 12
    }
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.value
        color: Theme.primary
        font.family: Theme.font; font.pixelSize: 12
        elide: Text.ElideRight
        width: 100
    }
}
