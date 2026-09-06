pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls

Scope {
    id: root

    function toggle() {
        window.visible = !window.visible
        if (window.visible) {
            content.forceActiveFocus()
        }
    }

    function close() {
        window.visible = false
    }

    PanelWindow {
        id: window
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        focusable: true
        color: "transparent"
        visible: false

        BackgroundEffect.blurRegion: Region {
            item: window.contentItem
        }

        Rectangle {
            id: content
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.22)
            focus: window.visible
            Keys.onEscapePressed: root.close()

            MouseArea {
                anchors.fill: parent
                onClicked: root.close()
            }

            Column {
                anchors.centerIn: parent
                spacing: 12

                Repeater {
                    model: [
                        { label: "Lock", cmd: "loginctl lock-session" },
                        { label: "Logout", cmd: "uwsm stop" },
                        { label: "Suspend", cmd: "systemctl suspend" },
                        { label: "Reboot", cmd: "systemctl reboot" },
                        { label: "Poweroff", cmd: "systemctl poweroff" },
                    ]
                    delegate: Rectangle {
                        width: 220
                        height: 48
                        radius: 10
                        color: buttonMouse.containsMouse ? Theme.accent : Theme.base

                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: buttonMouse.containsMouse ? Theme.background : Theme.text
                            font.pixelSize: 16
                        }

                        MouseArea {
                            id: buttonMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                root.close()
                                runCmd(modelData.cmd)
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: cmdProc
    }

    function runCmd(cmd) {
        cmdProc.command = [ "sh", "-c", cmd ]
        cmdProc.running = true
    }
}
