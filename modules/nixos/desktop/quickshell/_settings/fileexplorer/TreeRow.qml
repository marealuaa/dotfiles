import QtQuick

// Base tree row: indentation + icon/label on the left, optional right content
Row {
    id: root
    property int    depth:    0
    property string icon:     ""
    property string label:    ""
    property color  labelColor: Theme.fg
    property bool   isDir:    false

    height: 20
    width:  parent ? parent.width : 220
    spacing: 0
    leftPadding: 6 + depth * 14

    // Dir open indicator or file bullet
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text:  root.isDir ? " " : " "
        color: root.isDir ? Theme.blue : Theme.gray
        font.family: Theme.font; font.pixelSize: 12
    }

    // Icon
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text:  root.icon + " "
        color: root.labelColor
        font.family: Theme.font; font.pixelSize: 12
        visible: root.icon !== ""
    }

    // Label
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text:  root.label
        color: root.labelColor
        font.family: Theme.font; font.pixelSize: 12
        font.weight: root.isDir ? Font.Bold : Font.Normal
    }
}
