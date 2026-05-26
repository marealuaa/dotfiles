pragma Singleton
import Quickshell
import QtQuick

// Colors from theme.nix
Singleton {
    readonly property color base00: "#181616"  // bg
    readonly property color base01: "#0d0c0c"  // black
    readonly property color base02: "#2d4f67"  // blue-dark
    readonly property color base03: "#a6a69c"  // gray
    readonly property color base04: "#7fb4ca"  // cyan
    readonly property color base05: "#c5c9c5"  // fg
    readonly property color base06: "#938aa9"  // purple
    readonly property color base07: "#c5c9c5"  // light
    readonly property color base08: "#c4746e"  // red
    readonly property color base09: "#e46876"  // rose
    readonly property color base0A: "#c4b28a"  // yellow
    readonly property color base0B: "#8a9a7b"  // green
    readonly property color base0C: "#8ea4a2"  // teal
    readonly property color base0D: "#8ba4b0"  // blue
    readonly property color base0E: "#a292a3"  // magenta
    readonly property color base0F: "#7aa89f"  // mint

    // Semantic aliases
    readonly property color bg:        "#181616"
    readonly property color bg1:       "#1e1d2b"  // slightly lighter
    readonly property color bg2:       "#252535"  // panel headers
    readonly property color fg:        "#c5c9c5"
    readonly property color fg2:       "#a6a69c"
    readonly property color primary:   "#8ba4b0"  // blue  (base0D)
    readonly property color secondary: "#c4b28a"  // yellow (base0A)
    readonly property color border:    "#1e1d2b"
    readonly property color blue:      "#8ba4b0"
    readonly property color yellow:    "#c4b28a"
    readonly property color gray:      "#a6a69c"
    readonly property color red:       "#c4746e"

    // Font (from theme.nix font.mono)
    readonly property string font:    "JetBrains Mono Nerd Font"
    readonly property int    fontSize: 14

    // Animation
    readonly property int animSpeed: 100

    // Poll intervals (ms)
    readonly property int cpuPoll:    5000
    readonly property int ramPoll:    5000
    readonly property int diskPoll:   600000
    readonly property int pkgPoll:    10000
    readonly property int uptimePoll: 1000
}
