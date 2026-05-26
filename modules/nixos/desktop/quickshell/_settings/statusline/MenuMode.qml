import QtQuick
import QtQuick.Controls
import Quickshell

// Generic menu: ":" prompt + text input in the bar + floating popup above it.
// Set `items` (array of {displayName, ...}) and handle `onActivate(item)`.
Item {
    id: root

    property var items:       []
    property var filtered:    []
    property int selectedIdx: 0

    signal activate(var item)

    function filterItems(q) {
        var ql = q.toLowerCase()
        filtered = (ql === "")
            ? items.slice(0, 15)
            : items.filter(function(it) {
                return it.displayName.toLowerCase().includes(ql)
              }).slice(0, 15)
        selectedIdx = 0
    }

    onItemsChanged: filterItems(queryField.text)

    onVisibleChanged: {
        if (visible) {
            queryField.text = ""
            filterItems("")
            queryField.forceActiveFocus()
        }
    }

    // ── Inline prompt row ─────────────────────────────────────────────────
    Row {
        anchors.fill: parent
        spacing: 0

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text:  ":"
            color: Theme.primary
            font.family:    Theme.font
            font.pixelSize: Theme.fontSize
            leftPadding: 6
        }

        TextField {
            id: queryField
            anchors.verticalCenter: parent.verticalCenter
            width: 280
            color: Theme.fg
            font.family:    Theme.font
            font.pixelSize: Theme.fontSize
            background: null
            leftPadding: 4
            placeholderTextColor: Theme.gray

            onTextChanged: root.filterItems(text)

            Keys.onPressed: function(ev) {
                switch (ev.key) {
                case Qt.Key_Escape:
                    State.statusLineMode = "normal"
                    ev.accepted = true; break
                case Qt.Key_Return:
                case Qt.Key_Enter:
                    if (root.filtered.length > 0)
                        root.activate(root.filtered[root.selectedIdx])
                    State.statusLineMode = "normal"
                    ev.accepted = true; break
                case Qt.Key_Down:
                case Qt.Key_Tab:
                    if (root.selectedIdx < root.filtered.length - 1)
                        root.selectedIdx++
                    ev.accepted = true; break
                case Qt.Key_Up:
                    if (root.selectedIdx > 0)
                        root.selectedIdx--
                    ev.accepted = true; break
                }
            }
        }
    }

    // ── Floating popup anchored above bottom-left corner ──────────────────
    PanelWindow {
        id: popup
        visible: root.visible && root.filtered.length > 0

        anchors { bottom: true; left: true }
        color: Theme.bg1
        implicitWidth:  220
        implicitHeight: popupCol.implicitHeight

        Column {
            id: popupCol
            width: parent.width

            Repeater {
                model: root.filtered

                Rectangle {
                    width:  parent.width
                    height: 22
                    color:  index === root.selectedIdx ? Theme.primary : "transparent"

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 6
                        text:  modelData.displayName
                        color: index === root.selectedIdx ? Theme.bg : Theme.fg
                        font.family:    Theme.font
                        font.pixelSize: 12
                        font.weight:    Font.Bold
                        elide: Text.ElideRight
                        width: parent.width - 8
                    }
                }
            }
        }
    }
}
