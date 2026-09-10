import Quickshell
import QtQuick

Text {
    id: root
    required property var audio
    required property var theme
    anchors.verticalCenter: parent.verticalCenter
    text: (audio.muted ? "󰝟 " : "󰕾 ") + Math.round(audio.volume * 100)
    color: theme.text
    font.pixelSize: 14

    MouseArea {
        anchors.fill: parent
        onClicked: audioPopup.visible = !audioPopup.visible
    }

    PopupWindow {
        id: audioPopup
        anchor.item: root
        anchor.rect.y: root.height + 6
        anchor.rect.x: root.width / 2 - width / 2
        implicitWidth: 280
        implicitHeight: 32 + Math.max(0, audio.sinks.length * 36
            + Math.max(0, audio.sinks.length) * 4) + 16
        visible: false
        grabFocus: true
        color: "transparent"

        Rectangle {
            focus: audioPopup.visible
            anchors.fill: parent
            color: root.theme.background
            radius: 10

            Keys.onEscapePressed: function (event) {
                audioPopup.visible = false
                event.accepted = true
            }

            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Item {
                    width: parent.width
                    height: 32

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 32
                        text: Math.round(root.audio.volume * 100) + "%"
                        color: root.theme.text
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignRight
                    }

                    Rectangle {
                        id: volumeTrack
                        anchors.left: parent.left
                        anchors.leftMargin: 44
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: 6
                        radius: height / 2
                        color: root.theme.base

                        Rectangle {
                            width: volumeTrack.width * Math.max(0, Math.min(1, root.audio.volume))
                            height: parent.height
                            radius: parent.radius
                            color: root.theme.accent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: updateVolume(mouse.x)
                            onPositionChanged: {
                                if (pressed)
                                    updateVolume(mouse.x)
                            }

                            function updateVolume(position) {
                                if (root.audio.sink?.audio)
                                    root.audio.sink.audio.volume = Math.max(0, Math.min(1, position / width))
                            }
                        }
                    }
                }

                Repeater {
                    model: root.audio.sinks

                    delegate: Rectangle {
                        required property var modelData
                        width: parent.width
                        height: 36
                        radius: 6
                        color: modelData === root.audio.sink ? root.theme.accent : root.theme.base

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            text: modelData.description || modelData.nickname || modelData.name
                            color: modelData === root.audio.sink ? root.theme.background : root.theme.text
                            font.pixelSize: 13
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.audio.selectSink(modelData)
                                audioPopup.visible = false
                            }
                        }
                    }
                }
            }
        }
    }
}
