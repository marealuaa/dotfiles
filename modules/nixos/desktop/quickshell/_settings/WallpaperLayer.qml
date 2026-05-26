import QtQuick
import Quickshell
import Quickshell.Wayland

// Renders the active wallpaper at WlrLayer.Background — no external tool needed.
Scope {
    PanelWindow {
        anchors { top: true; bottom: true; left: true; right: true }
        exclusionMode: ExclusionMode.Ignore
        color: Theme.bg  // solid fallback while no wallpaper is set

        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.keyboardFocus: KeyboardFocus.None

        Image {
            id: wallpaperImage
            anchors.fill: parent
            fillMode:     Image.PreserveAspectCrop
            smooth:       true
            asynchronous: true
            source:       Wallpaper.path !== "" ? ("file://" + Wallpaper.path) : ""
            visible:      Wallpaper.path !== ""

            // Cross-fade on wallpaper change: fade out → swap source → fade in
            opacity: 1.0

            on_SourceChanged: fadeAnim.restart()

            SequentialAnimation {
                id: fadeAnim
                NumberAnimation {
                    target:   wallpaperImage
                    property: "opacity"
                    to:       0
                    duration: 250
                    easing.type: Easing.OutQuad
                }
                PropertyAction {
                    target:   wallpaperImage
                    property: "source"
                    value:    Wallpaper.path !== "" ? ("file://" + Wallpaper.path) : ""
                }
                NumberAnimation {
                    target:   wallpaperImage
                    property: "opacity"
                    to:       1
                    duration: 250
                    easing.type: Easing.InQuad
                }
            }
        }
    }
}
