import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    readonly property int outerGap: 4
    property string clockText: Qt.formatTime(new Date(), "HH:mm")
    property bool removableDeviceMounted: false

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.clockText = Qt.formatTime(new Date(), "HH:mm")
    }

    Process {
        id: pavuProc
    }

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

    function openPavu(tab) {
        pavuProc.command = [ "pavucontrol", "-t", tab ]
        pavuProc.running = true
    }

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
            implicitHeight: 36
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
                        id: leftModules
                        implicitWidth: workspaceRow.implicitWidth + 12
                        implicitHeight: 32
                        Layout.alignment: Qt.AlignBottom
                        color: Theme.background
                        radius: 8

                        Row {
                            id: workspaceRow
                            anchors.centerIn: parent
                            spacing: 4
                            Repeater {
                                model: Hyprland.workspaces.values.filter(function (workspace) {
                                    return !workspace.name.startsWith("special:")
                                })
                                delegate: Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 6
                                    color: modelData.focused ? Theme.accent : Theme.base

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.name
                                        color: modelData.focused ? Theme.background : Theme.text
                                        font.pixelSize: 12
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: modelData.activate()
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        id: rightModules
                        implicitWidth: rightContent.implicitWidth + 12
                        implicitHeight: 32
                        Layout.alignment: Qt.AlignBottom
                        color: Theme.background
                        radius: 8

                        Row {
                            id: rightContent
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 12

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.clockText
                                color: Theme.text
                                font.pixelSize: 14
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: Audio.muted ? "󰝟" : Math.round(Audio.volume * 100) + "%"
                                color: Theme.text
                                font.pixelSize: 14

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.openPavu("3")
                                }
                            }

                            Row {
                                id: trayItems
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 4

                                Repeater {
                                    model: SystemTray.items
                                    delegate: Rectangle {
                                        id: trayItem
                                        property bool isUdiskie: modelData.id.toLowerCase() === "udiskie"
                                        property real iconScale: /blueman|nm-applet|nextcloud/.test(modelData.id.toLowerCase()) ? 1.25 : 1
                                        width: isUdiskie && !root.removableDeviceMounted ? 0 : 24
                                        height: 24
                                        visible: !isUdiskie || root.removableDeviceMounted
                                        radius: 4
                                        color: Theme.base

                                        IconImage {
                                            anchors.centerIn: parent
                                            width: 16 * trayItem.iconScale
                                            height: 16 * trayItem.iconScale
                                            source: modelData.icon ?? ""
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                                            onClicked: function (mouse) {
                                                if (mouse.button === Qt.RightButton || modelData.onlyMenu) {
                                                    const position = mapToItem(bar, mouse.x, mouse.y)
                                                    modelData.display(panel, position.x, position.y)
                                                } else {
                                                    modelData.activate()
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                property real batteryPercentage: UPower.displayDevice.percentage * 100
                                property bool batteryCharging: UPower.displayDevice.state === UPowerDeviceState.Charging
                                visible: UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery
                                text: (batteryCharging ? "󱐋 " : "") + Math.round(batteryPercentage) + "%"
                                color: batteryCharging ? Theme.accent
                                    : batteryPercentage <= 10 ? "#ef4444"
                                    : batteryPercentage <= 30 ? "#f59e0b"
                                    : Theme.text
                                font.pixelSize: 14
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: (Notifications.doNotDisturb ? "" : "")
                                    + (Notifications.count > 0 ? " " + Notifications.count : "")
                                color: Theme.text
                                font.pixelSize: 14

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: ControlCenter.toggle()
                                }
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: ""
                                color: Theme.text
                                font.pixelSize: 14

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: PowerMenu.toggle()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
