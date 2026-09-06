pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Scope {
    id: root

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink, Pipewire.defaultAudioSource ]
    }

    readonly property real volume: Pipewire.defaultAudioSink?.audio?.volume ?? 0
    readonly property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false
    readonly property bool micMuted: Pipewire.defaultAudioSource?.audio?.muted ?? false

    signal osdRequested(string type, string value)

    function adjustVolume(delta) {
        const sink = Pipewire.defaultAudioSink?.audio
        if (sink) {
            sink.volume = Math.min(1, Math.max(0, sink.volume + delta))
        }
        osdRequested("volume", "")
    }

    function toggleMute() {
        const sink = Pipewire.defaultAudioSink?.audio
        if (sink) {
            sink.muted = !sink.muted
        }
        osdRequested("volume", "")
    }

    function toggleMicMute() {
        const src = Pipewire.defaultAudioSource?.audio
        if (src) {
            src.muted = !src.muted
        }
        osdRequested("mic", "")
    }
}
