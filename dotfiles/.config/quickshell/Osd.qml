pragma Singleton
import Quickshell
import QtQuick
import QtQuick.Layouts

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
        implicitHeight: 88
        visible: false

        Rectangle {
            anchors.centerIn: parent
            width: Math.max(240, content.implicitWidth + 48)
            height: root.type === "media" ? 68 : 48
            radius: 14
            color: Theme.base

            RowLayout {
                id: content
                anchors.centerIn: parent
                spacing: 12

                    Text {
                        visible: root.type === "media"
                        text: Media.status === "Playing" ? "Ⅱ" : "▶"
                    color: Theme.accent
                    font.pixelSize: 20

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Media.control("play-pause")
                    }
                }

                Text {
                    Layout.preferredWidth: root.type === "media" ? 220 : implicitWidth
                    Layout.maximumWidth: 260
                    text: {
                        if (root.type === "mic")
                            return Audio.micMuted ? "Mic muted" : "Mic unmuted"
                        if (root.type === "brightness")
                            return "Brightness " + Brightness.percent + "%"
                        if (root.type === "media")
                            return Media.trackText
                        if (Audio.muted)
                            return "Muted"
                        return "Volume " + Math.round(Audio.volume * 100) + "%"
                    }
                    color: Theme.text
                    font.pixelSize: root.type === "media" ? 15 : 18
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
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

    Connections {
        target: Media
        function onOsdRequested() {
            root.show("media")
        }
    }
}
