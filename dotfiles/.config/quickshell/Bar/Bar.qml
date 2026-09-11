import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    required property var theme
    required property var audio
    required property var notifications
    required property var controlCenter
    required property var powerMenu
    readonly property int outerGap: 4
    property bool removableDeviceMounted: false

    Process {
        id: mountedDevicesProc
        command: [ "lsblk", "-nrpo", "RM,MOUNTPOINT" ]
        stdout: StdioCollector {
            onStreamFinished: {
                root.removableDeviceMounted = this.text.split("\n").some(function (line) {
                    return /^1\s+\S+/.test(line)
                })
            }
        }
    }

    Timer {
        interval: 4000
        running: true
        repeat: true
        onTriggered: mountedDevicesProc.running = true
    }

    Component.onCompleted: mountedDevicesProc.running = true

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }
            margins {
                left: root.outerGap
                right: root.outerGap
            }
            implicitHeight: 26
            aboveWindows: true
            exclusiveZone: implicitHeight
            color: "transparent"

            Item {
                id: bar
                anchors.fill: parent

                RowLayout {
                    anchors.fill: parent
                    spacing: 12

                    Rectangle {
                        implicitWidth: workspace.implicitWidth
                        implicitHeight: 24
                        Layout.alignment: Qt.AlignBottom
                        color: root.theme.background
                        radius: 8

                        WorkspaceWidget {
                            id: workspace
                            anchors.centerIn: parent
                            monitor: panel.modelData
                            theme: root.theme
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        implicitWidth: rightContent.implicitWidth + 12
                        implicitHeight: 24
                        Layout.alignment: Qt.AlignBottom
                        color: root.theme.background
                        radius: 8

                        Row {
                            id: rightContent
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 10

                            ClockWidget { theme: root.theme }
                            HyprsunsetWidget { theme: root.theme }
                            AudioWidget { audio: root.audio; theme: root.theme }
                            BluetoothWidget { theme: root.theme }
                            TrayWidget {
                                bar: bar
                                panel: panel
                                removableDeviceMounted: root.removableDeviceMounted
                            }
                            BatteryWidget { theme: root.theme }
                            NotificationsWidget {
                                theme: root.theme
                                notifications: root.notifications
                                controlCenter: root.controlCenter
                            }
                            PowerButton { theme: root.theme; powerMenu: root.powerMenu }
                        }
                    }
                }
            }
        }
    }
}
