pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property real brightness: 0.5

    Process {
        command: ["bash", "-c", "echo \"scale=4; $(brightnessctl get) / $(brightnessctl max)\" | bc"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.brightness = parseFloat(this.text.trim()) || 0.5
        }
    }

    Process {
        id: setProc
        command: ["brightnessctl", "set", "50%", "-q"]
    }

    function setBrightness(value) {
        value = Math.max(0.01, Math.min(1.0, value))
        root.brightness = value
        setProc.command = ["brightnessctl", "set", Math.round(value * 100) + "%", "-q"]
        setProc.running = true
    }
}
