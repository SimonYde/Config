import Quickshell
import Quickshell.Bluetooth
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
    property bool removableDeviceMounted: false

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
                        id: leftModules
                        implicitWidth: workspaceRow.implicitWidth + 12
                        implicitHeight: 24
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
                                    color: modelData.focused ? Theme.accent : "transparent"

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
                        implicitHeight: 24
                        Layout.alignment: Qt.AlignBottom
                        color: Theme.background
                        radius: 8

                        Row {
                            id: rightContent
                            anchors.fill: parent
                            anchors.margins: 6
                            spacing: 10

                            SystemClock {
                                id: clock
                                precision: SystemClock.Seconds
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: Qt.formatDateTime(clock.date, "HH:mm")
                                color: Theme.text
                                font.pixelSize: 14
                            }

                            Text {
                                id: volumeControl
                                anchors.verticalCenter: parent.verticalCenter
                                text: (Audio.muted ? "󰝟 " : "󰕾 ") + Math.round(Audio.volume * 100)
                                color: Theme.text
                                font.pixelSize: 14

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: audioPopup.visible = !audioPopup.visible
                                }
                            }

                            PopupWindow {
                                id: audioPopup
                                anchor.item: volumeControl
                                anchor.rect.y: volumeControl.height + 6
                                anchor.rect.x: volumeControl.width / 2 - width / 2
                                implicitWidth: 280
                                implicitHeight: Math.max(52,
                                    Audio.sinks.length * 36
                                    + Math.max(0, Audio.sinks.length - 1) * 4 + 16)
                                visible: false
                                grabFocus: true
                                color: "transparent"

                                Rectangle {
                                    focus: audioPopup.visible
                                    anchors.fill: parent
                                    color: Theme.background
                                    radius: 10

                                    Keys.onEscapePressed: function (event) {
                                        audioPopup.visible = false
                                        event.accepted = true
                                    }

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        spacing: 4

                                        Repeater {
                                            model: Audio.sinks

                                            delegate: Rectangle {
                                                required property var modelData
                                                width: parent.width
                                                height: 36
                                                radius: 6
                                                color: modelData === Audio.sink ? Theme.accent : Theme.base

                                                Text {
                                                    anchors.fill: parent
                                                    anchors.leftMargin: 10
                                                    anchors.rightMargin: 10
                                                    text: modelData.description || modelData.nickname || modelData.name
                                                    color: modelData === Audio.sink ? Theme.background : Theme.text
                                                    font.pixelSize: 13
                                                    elide: Text.ElideRight
                                                    verticalAlignment: Text.AlignVCenter
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        Audio.selectSink(modelData)
                                                        audioPopup.visible = false
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Text {
                                id: bluetoothControl
                                anchors.verticalCenter: parent.verticalCenter
                                text: Bluetooth.defaultAdapter?.enabled
                                    ? Bluetooth.devices.values.some(function (device) { return device.connected }) ? "󰂱" : "󰂯"
                                    : "󰂲"
                                color: Bluetooth.defaultAdapter?.enabled ? Theme.text : Theme.muted
                                font.pixelSize: 16

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: bluetoothPopup.visible = !bluetoothPopup.visible
                                }
                            }

                            PopupWindow {
                                id: bluetoothPopup
                                anchor.item: bluetoothControl
                                anchor.rect.y: bluetoothControl.height + 6
                                anchor.rect.x: bluetoothControl.width / 2 - width / 2
                                implicitWidth: 320
                                implicitHeight: Math.max(72, 48 + Bluetooth.devices.values.length * 44)
                                visible: false
                                grabFocus: true
                                color: "transparent"

                                Rectangle {
                                    focus: bluetoothPopup.visible
                                    anchors.fill: parent
                                    color: Theme.background
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
                                                color: Theme.text
                                                font.pixelSize: 14
                                            }

                                            Item {
                                                width: parent.width - bluetoothTitle.implicitWidth - 144
                                                height: 1
                                            }

                                            Rectangle {
                                                width: 60
                                                height: 28
                                                radius: 6
                                                color: Bluetooth.defaultAdapter?.discovering ? Theme.accent : Theme.base

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: Bluetooth.defaultAdapter?.discovering ? "Stop" : "Scan"
                                                    color: Bluetooth.defaultAdapter?.discovering ? Theme.background : Theme.text
                                                    font.pixelSize: 12
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    enabled: Bluetooth.defaultAdapter !== null
                                                    onClicked: Bluetooth.defaultAdapter.discovering = !Bluetooth.defaultAdapter.discovering
                                                }
                                            }

                                            Rectangle {
                                                width: 60
                                                height: 28
                                                radius: 6
                                                color: Bluetooth.defaultAdapter?.enabled ? Theme.base : Theme.accent

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: Bluetooth.defaultAdapter?.enabled ? "On" : "Off"
                                                    color: Bluetooth.defaultAdapter?.enabled ? Theme.text : Theme.background
                                                    font.pixelSize: 12
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    enabled: Bluetooth.defaultAdapter !== null
                                                    onClicked: Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
                                                }
                                            }
                                        }

                                        Repeater {
                                            model: Bluetooth.devices.values

                                            delegate: Rectangle {
                                                required property var modelData
                                                width: parent.width
                                                height: 40
                                                radius: 6
                                                color: modelData.connected ? Theme.accent : Theme.base

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
                                                        color: modelData.connected ? Theme.background : Theme.text
                                                        font.pixelSize: 13
                                                        elide: Text.ElideRight
                                                    }

                                                    Text {
                                                        text: modelData.pairing ? "Pairing..."
                                                            : modelData.batteryAvailable ? "Battery " + Math.round(modelData.battery * 100) + "%"
                                                            : modelData.paired ? "Paired" : "Not paired"
                                                        color: modelData.connected ? Theme.background : Theme.muted
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
                                                    color: modelData.connected ? Theme.base : Theme.accent

                                                    Text {
                                                        anchors.centerIn: parent
                                                        text: modelData.pairing ? "Cancel"
                                                            : modelData.connected ? "Disconnect"
                                                            : modelData.paired ? "Connect" : "Pair"
                                                        color: modelData.connected ? Theme.text : Theme.background
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
                                            color: Theme.muted
                                            horizontalAlignment: Text.AlignHCenter
                                            font.pixelSize: 12
                                        }
                                    }
                                }
                            }

                            Row {
                                id: trayItems
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2

                                Repeater {
                                    model: SystemTray.items
                                    delegate: Rectangle {
                                        id: trayItem
                                        property bool isUdiskie: modelData.id.toLowerCase() === "udiskie"
                                        property real iconScale: /nm-applet|nextcloud/.test(modelData.id.toLowerCase()) ? 1.25 : 1
                                        width: isUdiskie && !root.removableDeviceMounted ? 0 : 24
                                        height: 24
                                        visible: !isUdiskie || root.removableDeviceMounted
                                        radius: 4
                                        color: "transparent"

                                        IconImage {
                                            implicitSize: 16 * trayItem.iconScale
                                            anchors.centerIn: parent
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
                                id: batteryControl
                                anchors.verticalCenter: parent.verticalCenter
                                property real batteryPercentage: UPower.displayDevice.percentage * 100
                                property bool batteryCharging: UPower.displayDevice.state === UPowerDeviceState.Charging
                                visible: UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery
                                text: (batteryCharging ? "󰂄" : "󰁹") + " " + Math.round(batteryPercentage)
                                color: batteryCharging ? Theme.accent
                                    : batteryPercentage <= 10 ? "#ef4444"
                                    : batteryPercentage <= 30 ? "#f59e0b"
                                    : Theme.text
                                font.pixelSize: 14

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: powerProfilePopup.visible = !powerProfilePopup.visible
                                }
                            }

                            PopupWindow {
                                id: powerProfilePopup
                                anchor.item: batteryControl
                                anchor.rect.y: batteryControl.height + 6
                                anchor.rect.x: batteryControl.width / 2 - width / 2
                                implicitWidth: 240
                                implicitHeight: 80 + (PowerProfiles.hasPerformanceProfile ? 40 : 0)
                                visible: false
                                grabFocus: true
                                color: "transparent"

                                Rectangle {
                                    focus: powerProfilePopup.visible
                                    anchors.fill: parent
                                    color: Theme.background
                                    radius: 10

                                    Keys.onEscapePressed: function (event) {
                                        powerProfilePopup.visible = false
                                        event.accepted = true
                                    }

                                    Column {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        spacing: 4

                                        Text {
                                            width: parent.width
                                            height: 28
                                            text: "Power profile: " + PowerProfile.toString(PowerProfiles.profile)
                                            color: Theme.text
                                            font.pixelSize: 13
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        Repeater {
                                            model: PowerProfiles.hasPerformanceProfile
                                                ? [PowerProfile.PowerSaver, PowerProfile.Balanced, PowerProfile.Performance]
                                                : [PowerProfile.PowerSaver, PowerProfile.Balanced]

                                            delegate: Rectangle {
                                                required property var modelData
                                                width: parent.width
                                                height: 36
                                                radius: 6
                                                color: PowerProfiles.profile === modelData ? Theme.accent : Theme.base

                                                Text {
                                                    anchors.fill: parent
                                                    anchors.leftMargin: 10
                                                    text: PowerProfile.toString(modelData)
                                                    color: PowerProfiles.profile === modelData ? Theme.background : Theme.text
                                                    font.pixelSize: 12
                                                    verticalAlignment: Text.AlignVCenter
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    enabled: PowerProfiles.profile !== modelData
                                                    onClicked: {
                                                        PowerProfiles.profile = modelData
                                                        powerProfilePopup.visible = false
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
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
