import Quickshell
import Quickshell.Services.UPower
import QtQuick

Text {
    id: root
    required property var theme
    anchors.verticalCenter: parent.verticalCenter
    property real batteryPercentage: UPower.displayDevice.percentage * 100
    property bool batteryCharging: UPower.displayDevice.state === UPowerDeviceState.Charging
    visible: UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery
    text: (batteryCharging ? "󰂄" : "󰁹") + " " + Math.round(batteryPercentage)
    color: batteryCharging ? theme.accent
        : batteryPercentage <= 10 ? "#ef4444"
        : batteryPercentage <= 30 ? "#f59e0b"
        : theme.text
    font.pixelSize: 14

    MouseArea {
        anchors.fill: parent
        onClicked: powerProfilePopup.visible = !powerProfilePopup.visible
    }

    PopupWindow {
        id: powerProfilePopup
        anchor.item: root
        anchor.rect.y: root.height + 6
        anchor.rect.x: root.width / 2 - width / 2
        implicitWidth: 240
        implicitHeight: 80 + (PowerProfiles.hasPerformanceProfile ? 40 : 0)
        visible: false
        grabFocus: true
        color: "transparent"

        Rectangle {
            focus: powerProfilePopup.visible
            anchors.fill: parent
            color: root.theme.background
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
                    color: root.theme.text
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
                        color: PowerProfiles.profile === modelData ? root.theme.accent : root.theme.base

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            text: PowerProfile.toString(modelData)
                            color: PowerProfiles.profile === modelData ? root.theme.background : root.theme.text
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
}
