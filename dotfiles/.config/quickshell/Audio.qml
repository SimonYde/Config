pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Scope {
    id: root

    PwObjectTracker {
        objects: [ root.sink, Pipewire.defaultAudioSource ]
    }

    property var sink: Pipewire.defaultAudioSink
    readonly property var sinks: Pipewire.nodes.values.filter(function (node) {
        return node.isSink && !node.isStream && node.audio
    })
    readonly property real volume: root.sink?.audio?.volume ?? 0
    readonly property bool muted: root.sink?.audio?.muted ?? false
    readonly property bool micMuted: Pipewire.defaultAudioSource?.audio?.muted ?? false
    readonly property string sinkName: root.sink
        ? (root.sink.description || root.sink.nickname || root.sink.name || "Unknown output")
        : "No output"

    signal osdRequested(string type, string value)

    function selectSink(sink) {
        if (!sink)
            return
        root.sink = sink
        Pipewire.preferredDefaultAudioSink = sink
    }

    function adjustVolume(delta) {
        const sink = root.sink?.audio
        if (sink) {
            sink.volume = Math.min(1, Math.max(0, sink.volume + delta))
        }
        osdRequested("volume", "")
    }

    function toggleMute() {
        const sink = root.sink?.audio
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

    Connections {
        target: Pipewire
        function onDefaultAudioSinkChanged() {
            root.sink = Pipewire.defaultAudioSink
        }
    }
}
