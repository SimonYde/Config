pragma Singleton
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Scope {
    id: root

    function toggle() {
        window.visible = !window.visible
        if (window.visible) {
            keyHandler.forceActiveFocus()
        }
    }

    function close() {
        window.visible = false
    }

    PanelWindow {
        id: window
        anchors {
            right: true
            top: true
            bottom: true
        }
        implicitWidth: 380
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        focusable: true
        visible: false

        Rectangle {
            id: content
            anchors.fill: parent
            color: Theme.background

            Item {
                id: keyHandler
                anchors.fill: parent
                focus: window.visible
                Keys.onEscapePressed: root.close()

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    RowLayout {
                        Text {
                            text: "Notifications"
                            color: Theme.text
                            font.pixelSize: 20
                            font.bold: true
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Button {
                            id: clearButton
                            text: "Clear"
                            focusPolicy: Qt.NoFocus
                            background: Rectangle {
                                color: clearButton.hovered ? Theme.accent : Theme.base
                                radius: 4
                            }
                            contentItem: Text {
                                text: clearButton.text
                                color: clearButton.hovered ? Theme.background : Theme.text
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: Notifications.closeAll()
                        }
                        Button {
                            id: muteButton
                             text: Notifications.doNotDisturb ? "Unmute" : "Mute"
                            focusPolicy: Qt.NoFocus
                            background: Rectangle {
                                color: muteButton.hovered ? Theme.accent : Theme.base
                                radius: 4
                            }
                            contentItem: Text {
                                text: muteButton.text
                                color: muteButton.hovered ? Theme.background : Theme.text
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: Notifications.doNotDisturb = !Notifications.doNotDisturb
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: Notifications.groupedNotifications
                        spacing: 8

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: groupColumn.implicitHeight
                            color: "transparent"

                            Column {
                                id: groupColumn
                                width: parent.width
                                spacing: 6

                                Text {
                                    text: modelData.appName
                                    color: Theme.muted
                                    font.pixelSize: 13
                                    font.bold: true
                                }

                                Repeater {
                                    model: modelData.notifications

                                    delegate: Rectangle {
                                        required property var modelData
                                        width: groupColumn.width
                                        height: Math.max(body.implicitHeight + 24, 56)
                                        color: Theme.base
                                        radius: 12

                                        IconImage {
                                            anchors.left: parent.left
                                            anchors.top: parent.top
                                            anchors.leftMargin: 12
                                            anchors.topMargin: 12
                                            width: 32
                                            height: 32
                                            source: modelData.appIcon ?? ""
                                        }

                                        Column {
                                            id: body
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            anchors.leftMargin: modelData.appIcon ? 56 : 12
                                            anchors.rightMargin: 12
                                            anchors.topMargin: 12

                                            Text {
                                                text: modelData.summary
                                                color: Theme.text
                                                font.pixelSize: 16
                                                font.bold: true
                                                wrapMode: Text.Wrap
                                                width: parent.width
                                            }
                                            Text {
                                                text: modelData.body
                                                color: Theme.text
                                                wrapMode: Text.Wrap
                                                width: parent.width
                                            }
                                        }

                                        Text {
                                            anchors.top: parent.top
                                            anchors.right: parent.right
                                            anchors.topMargin: 6
                                            anchors.rightMargin: 10
                                            text: "×"
                                            color: dismissMouse.containsMouse ? Theme.accent : Theme.muted
                                            font.pixelSize: 20

                                            MouseArea {
                                                id: dismissMouse
                                                anchors.fill: parent
                                                anchors.margins: -6
                                                hoverEnabled: true
                                                onClicked: modelData.dismiss()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
