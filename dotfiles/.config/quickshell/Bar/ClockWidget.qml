import Quickshell
import Quickshell.Widgets
import QtQuick
import qs.Common

Rectangle {
    id: root

    required property var theme
    required property var media
    required property var audio

    implicitWidth: clockText.implicitWidth + 20
    implicitHeight: 24
    color: theme.background
    radius: 8
    border.color: theme.accent
    border.width: 1

    Text {
        id: clockText
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "HH:mm")
        color: root.theme.text
        font.pixelSize: 14
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    MouseArea {
        anchors.fill: parent
        onClicked: overviewPopup.visible = !overviewPopup.visible
    }

    PopupWindow {
        id: overviewPopup
        anchor.item: root
        anchor.rect.y: root.height + 6
        anchor.rect.x: root.width / 2 - width / 2
        implicitWidth: 450
        implicitHeight: overviewContent.implicitHeight + 20
        visible: false
        grabFocus: true
        color: "transparent"

        PopupSurface {
            theme: root.theme
            focus: overviewPopup.visible
            anchors.fill: parent

            Keys.onEscapePressed: function (event) {
                overviewPopup.visible = false
                event.accepted = true
            }

            Column {
                id: overviewContent
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Text {
                    width: parent.width
                    text: Qt.formatDateTime(clock.date, "dddd d. MMMM yyyy")
                    color: root.theme.brightText
                    font.pixelSize: 18
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: root.theme.surface
                }

                Row {
                    width: parent.width
                    spacing: 12

                    ClippingRectangle {
                        id: artFrame
                        width: 56
                        height: 56
                        radius: 8
                        color: root.theme.base

                        Image {
                            id: artImage
                            anchors.fill: parent
                            source: root.media.player ? root.media.player.trackArtUrl : ""
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            visible: status === Image.Ready
                        }

                        Text {
                            anchors.centerIn: parent
                            visible: !artImage.visible
                            text: "\uf001"
                            color: root.theme.muted
                            font.pixelSize: 22
                        }
                    }

                    Column {
                        width: parent.width - artFrame.width - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            width: parent.width
                            text: root.media.player
                                ? (root.media.player.trackTitle || "Unknown track")
                                : "No media playing"
                            color: root.theme.text
                            font.pixelSize: 15
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width
                            visible: text !== ""
                            text: root.media.player ? root.media.player.trackArtist : ""
                            color: root.theme.muted
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width
                            visible: text !== ""
                            text: root.media.player ? root.media.player.trackAlbum : ""
                            color: root.theme.muted
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 28
                    visible: !!root.media.player

                    Text {
                        text: "\uf048"
                        color: prevMouse.containsMouse ? root.theme.accent : root.theme.text
                        font.pixelSize: 18

                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            anchors.margins: -6
                            hoverEnabled: true
                            onClicked: {
                                const p = root.media.player
                                if (p && p.canGoPrevious) {
                                    root.media.activePlayer = p
                                    p.previous()
                                }
                            }
                        }
                    }

                    Text {
                        text: root.media.player && root.media.player.isPlaying ? "\uf04c" : "\uf04b"
                        color: playMouse.containsMouse ? root.theme.accent : root.theme.text
                        font.pixelSize: 18

                        MouseArea {
                            id: playMouse
                            anchors.fill: parent
                            anchors.margins: -6
                            hoverEnabled: true
                            onClicked: {
                                const p = root.media.player
                                if (p && p.canTogglePlaying) {
                                    root.media.activePlayer = p
                                    p.togglePlaying()
                                }
                            }
                        }
                    }

                    Text {
                        text: "\uf051"
                        color: nextMouse.containsMouse ? root.theme.accent : root.theme.text
                        font.pixelSize: 18

                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            anchors.margins: -6
                            hoverEnabled: true
                            onClicked: {
                                const p = root.media.player
                                if (p && p.canGoNext) {
                                    root.media.activePlayer = p
                                    p.next()
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: root.theme.surface
                }

                Row {
                    width: parent.width
                    spacing: 8

                    Text {
                        text: root.audio.muted ? "\uf026" : "\uf028"
                        color: root.theme.text
                        font.pixelSize: 14
                    }

                    Rectangle {
                        id: volumeTrack
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 96
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
                            onPressed: function (mouse) {
                                updateVolume(mouse.x)
                            }
                            onPositionChanged: function (mouse) {
                                if (pressed)
                                    updateVolume(mouse.x)
                            }

                            function updateVolume(position) {
                                if (root.audio.sink?.audio)
                                    root.audio.sink.audio.volume = Math.max(0, Math.min(1, position / width))
                            }
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: Math.round(root.audio.volume * 100) + "%"
                        color: root.theme.muted
                        font.pixelSize: 13
                    }
                }

                Text {
                    width: parent.width
                    text: (root.audio.muted ? "Muted · " : "") + root.audio.sinkName
                    color: root.theme.muted
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }
            }
        }
    }
}
