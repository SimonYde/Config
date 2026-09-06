pragma Singleton
import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Scope {
    id: root

    property var activePlayer: null
    readonly property var player: resolvePlayer()

    function resolvePlayer() {
        const players = Mpris.players.values
        for (const player of players) {
            if (player.isPlaying)
                return player
        }
        if (activePlayer && players.indexOf(activePlayer) !== -1)
            return activePlayer
        return players.length > 0 ? players[0] : null
    }
    readonly property string status: player ? MprisPlaybackState.toString(player.playbackState) : ""
    readonly property string trackText: player
        ? (player.trackArtist ? player.trackTitle + " - " + player.trackArtist : player.trackTitle)
        : "No media playing"

    signal osdRequested

    function control(action) {
        const target = resolvePlayer()
        if (target) {
            activePlayer = target
            if (action === "play-pause" && target.canTogglePlaying)
                target.togglePlaying()
            else if (action === "next" && target.canGoNext)
                target.next()
            else if (action === "prev" && target.canGoPrevious)
                target.previous()
        }

        osdRequested()
    }
}
