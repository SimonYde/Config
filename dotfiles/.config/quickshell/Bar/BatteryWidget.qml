import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import qs.Common

Text {
    id: root
    required property var theme
    property bool hasPerformanceProfile: false
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

    Process {
        id: powerProfilesProc
        command: ["power-profiles", "--json"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const profiles = JSON.parse(this.text)
                    root.hasPerformanceProfile = profiles.some(function (profile) {
                        return profile.name === "performance"
                    })
                } catch (error) {
                    root.hasPerformanceProfile = false
                }
            }
        }
    }

    Component.onCompleted: powerProfilesProc.running = true

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
        implicitHeight: 16 + 28 + 4 * (root.hasPerformanceProfile ? 3 : 2)
            + 36 * (root.hasPerformanceProfile ? 3 : 2)
        visible: false
        grabFocus: true
        color: "transparent"

        PopupSurface {
            theme: root.theme
            focus: powerProfilePopup.visible
            anchors.fill: parent

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
                    model: root.hasPerformanceProfile
                        ? [PowerProfile.PowerSaver, PowerProfile.Balanced, PowerProfile.Performance]
                        : [PowerProfile.PowerSaver, PowerProfile.Balanced]

                    delegate: SelectorButton {
                        required property var modelData
                        width: parent.width
                        height: 36
                        theme: root.theme
                        active: PowerProfiles.profile === modelData
                        text: PowerProfile.toString(modelData)
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
