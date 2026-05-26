import QtQuick
import Quickshell

Item {
    anchors.fill: parent

    property var appItems: {
        var result = []
        for (var i = 0; i < DesktopEntries.applications.length; i++) {
            var app = DesktopEntries.applications[i]
            if (app.noDisplay) continue
            result.push({ displayName: app.name || app.id, entry: app })
        }
        result.sort((a, b) => a.displayName.localeCompare(b.displayName))
        return result
    }

    MenuMode {
        anchors.fill: parent
        items: parent.appItems
        onActivate: function(item) { item.entry.execute() }
    }
}
