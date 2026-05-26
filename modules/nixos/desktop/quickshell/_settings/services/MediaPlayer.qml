pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

// Generic MPRIS media player singleton.
// Picks the best active player using a priority order:
//   Spotify > Firefox > Chromium > any other playing player > any player
Singleton {
    id: root

    // The currently selected player, or null
    readonly property MprisPlayer player: _selectPlayer()

    readonly property bool   available:   player !== null
    readonly property string trackTitle:  available ? (player.trackTitle  || "No Title")       : "No Title"
    readonly property string trackArtist: available ? (player.trackArtist || "Unknown Artist") : "Unknown Artist"
    readonly property string trackAlbum:  available ? (player.trackAlbum  || "Unknown Album")  : "Unknown Album"
    readonly property bool   isPlaying:   available && player.isPlaying
    readonly property real   volume:      available ? player.volume : 0.5

    // Name shown in the UI (e.g. "Spotify", "Firefox")
    readonly property string playerName:  available ? _prettyName(player.identity) : "No Player"

    function previous()   { if (available && player.canGoPrevious)    player.previous() }
    function togglePlay() { if (available && player.canTogglePlaying)  player.togglePlaying() }
    function next()       { if (available && player.canGoNext)         player.next() }
    function setVolume(v) { if (available) player.volume = v }

    // ── Player selection ──────────────────────────────────────────────────

    // Priority list: lower index = higher priority
    readonly property var _priority: [
        "spotify",
        "firefox",
        "chromium",
        "chrome",
        "brave",
        "vlc",
        "mpv",
        "rhythmbox",
        "audacious",
        "clementine",
    ]

    function _selectPlayer() {
        var players = Mpris.players
        if (!players || players.length === 0) return null

        // 1. Look for highest-priority player that is actively playing
        for (var p = 0; p < _priority.length; p++) {
            for (var i = 0; i < players.length; i++) {
                if (players[i].identity.toLowerCase().includes(_priority[p])
                        && players[i].isPlaying)
                    return players[i]
            }
        }

        // 2. Look for highest-priority player regardless of play state
        for (var p2 = 0; p2 < _priority.length; p2++) {
            for (var j = 0; j < players.length; j++) {
                if (players[j].identity.toLowerCase().includes(_priority[p2]))
                    return players[j]
            }
        }

        // 3. Fall back to whichever player is playing
        for (var k = 0; k < players.length; k++) {
            if (players[k].isPlaying) return players[k]
        }

        // 4. Fall back to the first player in the list
        return players[0]
    }

    function _prettyName(identity) {
        if (!identity) return "Unknown"
        // Capitalize first letter
        return identity.charAt(0).toUpperCase() + identity.slice(1)
    }
}
