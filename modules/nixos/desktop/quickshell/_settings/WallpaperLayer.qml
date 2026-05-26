import QtQuick
import Quickshell
import Quickshell.Wayland
Scope {
    PanelWindow {
        id: bgWindow

        anchors { top: true; bottom: true; left: true; right: true }
        exclusionMode: ExclusionMode.Ignore
        color: Theme.bg

        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.keyboardFocus: KeyboardFocus.None

        Image {
            id: imgA
            anchors.fill: parent
            fillMode:  Image.PreserveAspectCrop
            smooth:    true
            asynchronous: true
            opacity:   1.0
            Behavior on opacity {
                NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
            }
        }

        Image {
            id: imgB
            anchors.fill: parent
            fillMode:  Image.PreserveAspectCrop
            smooth:    true
            asynchronous: true
            opacity:   0.0
            Behavior on opacity {
                NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
            }
        }

        property bool aOnTop: true

        function setWallpaper(path) {
            var src = path !== "" ? ("file://" + path) : ""
            if (bgWindow.aOnTop) {
                imgB.source  = src
                imgB.opacity = 1.0
                imgA.opacity = 0.0
            } else {
                imgA.source  = src
                imgA.opacity = 1.0
                imgB.opacity = 0.0
            }
            bgWindow.aOnTop = !bgWindow.aOnTop
        }

        Connections {
            target: Wallpaper
            function onPathChanged() {
                bgWindow.setWallpaper(Wallpaper.path)
            }
        }

        Component.onCompleted: bgWindow.setWallpaper(Wallpaper.path)
    }
}
