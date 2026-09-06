pragma Singleton
import Quickshell
import QtQuick

Scope {
    id: root

    property string type: ""

    function show(t) {
        type = t
        osdWindow.visible = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: osdWindow.visible = false
    }

    PanelWindow {
        id: osdWindow
        anchors {
            top: true
            left: true
            right: true
        }
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"
        implicitHeight: 72
        visible: false

        Rectangle {
            anchors.centerIn: parent
            width: Math.max(200, content.implicitWidth + 48)
            height: 48
            radius: 24
            color: Theme.base

            Row {
                id: content
                anchors.centerIn: parent
                spacing: 12

                Text {
                    text: {
                        if (root.type === "mic")
                            return Audio.micMuted ? "Mic muted" : "Mic unmuted"
                        if (root.type === "brightness")
                            return "Brightness " + Brightness.percent + "%"
                        if (root.type === "media")
                            return "Media"
                        if (Audio.muted)
                            return "Muted"
                        return "Volume " + Math.round(Audio.volume * 100) + "%"
                    }
                    color: Theme.text
                    font.pixelSize: 18
                }
            }
        }
    }

    Connections {
        target: Audio
        function onOsdRequested(t, v) {
            root.show(t)
        }
    }
}
