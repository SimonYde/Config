import Quickshell
import Quickshell.Bluetooth
import QtQuick

Text {
    id: root
    required property var theme
    anchors.verticalCenter: parent.verticalCenter
    text: Bluetooth.defaultAdapter?.enabled
        ? Bluetooth.devices.values.some(function (device) { return device.connected }) ? "󰂱" : "󰂯"
        : "󰂲"
    color: Bluetooth.defaultAdapter?.enabled ? theme.text : theme.muted
    font.pixelSize: 16

    MouseArea {
        anchors.fill: parent
        onClicked: bluetoothPopup.visible = !bluetoothPopup.visible
    }

    PopupWindow {
        id: bluetoothPopup
        anchor.item: root
        anchor.rect.y: root.height + 6
        anchor.rect.x: root.width / 2 - width / 2
        implicitWidth: 320
        implicitHeight: Math.max(72, 48 + Bluetooth.devices.values.length * 44)
        visible: false
        grabFocus: true
        color: "transparent"

        Rectangle {
            focus: bluetoothPopup.visible
            anchors.fill: parent
            color: root.theme.background
            radius: 10

            Keys.onEscapePressed: function (event) {
                bluetoothPopup.visible = false
                event.accepted = true
            }

            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Row {
                    width: parent.width
                    height: 32
                    spacing: 8

                    Text {
                        id: bluetoothTitle
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Bluetooth"
                        color: root.theme.text
                        font.pixelSize: 14
                    }

                    Item {
                        width: parent.width - bluetoothTitle.implicitWidth - 144
                        height: 1
                    }

                    BluetoothAction {
                        theme: root.theme
                        width: 60
                        text: Bluetooth.defaultAdapter?.discovering ? "Stop" : "Scan"
                        active: Bluetooth.defaultAdapter?.discovering ?? false
                        enabled: Bluetooth.defaultAdapter !== null
                        onClicked: Bluetooth.defaultAdapter.discovering = !Bluetooth.defaultAdapter.discovering
                    }

                    BluetoothAction {
                        theme: root.theme
                        width: 60
                        text: Bluetooth.defaultAdapter?.enabled ? "On" : "Off"
                        active: !(Bluetooth.defaultAdapter?.enabled ?? false)
                        enabled: Bluetooth.defaultAdapter !== null
                        onClicked: Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
                    }
                }

                Repeater {
                    model: Bluetooth.devices.values

                    delegate: Rectangle {
                        required property var modelData
                        width: parent.width
                        height: 40
                        radius: 6
                        color: modelData.connected ? root.theme.accent : root.theme.base

                        Column {
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.right: deviceAction.left
                            anchors.rightMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            Text {
                                width: parent.width
                                text: modelData.name || modelData.deviceName || modelData.address
                                color: modelData.connected ? root.theme.background : root.theme.text
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }

                            Text {
                                text: modelData.pairing ? "Pairing..."
                                    : modelData.batteryAvailable ? "Battery " + Math.round(modelData.battery * 100) + "%"
                                    : modelData.paired ? "Paired" : "Not paired"
                                color: modelData.connected ? root.theme.background : root.theme.muted
                                font.pixelSize: 11
                            }
                        }

                        Rectangle {
                            id: deviceAction
                            anchors.right: parent.right
                            anchors.rightMargin: 6
                            anchors.verticalCenter: parent.verticalCenter
                            width: 72
                            height: 28
                            radius: 5
                            color: modelData.connected ? root.theme.base : root.theme.accent

                            Text {
                                anchors.centerIn: parent
                                text: modelData.pairing ? "Cancel"
                                    : modelData.connected ? "Disconnect"
                                    : modelData.paired ? "Connect" : "Pair"
                                color: modelData.connected ? root.theme.text : root.theme.background
                                font.pixelSize: 11
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (modelData.pairing)
                                        modelData.cancelPair()
                                    else if (modelData.connected)
                                        modelData.disconnect()
                                    else if (modelData.paired)
                                        modelData.connect()
                                    else
                                        modelData.pair()
                                }
                            }
                        }
                    }
                }

                Text {
                    width: parent.width
                    visible: Bluetooth.devices.values.length === 0
                    text: "No Bluetooth devices"
                    color: root.theme.muted
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 12
                }
            }
        }
    }
}
