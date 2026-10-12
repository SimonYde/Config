import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import qs.Common

Text {
    id: root
    required property var theme
    property bool hasPerformanceProfile: false
    property bool hasGamingSpecialisation: false
    property bool gamingActive: false
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

    function refresh() {
        powerProfilesProc.running = true
        specialisationsProc.running = true
        activeSpecialisationProc.running = true
    }

    function switchGaming() {
        specialisationSwitchProc.command = root.gamingActive
            ? [ "specialisation" ]
            : [ "specialisation", "gaming" ]
        specialisationSwitchProc.running = true
        powerProfilePopup.visible = false
    }

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

    Process {
        id: specialisationsProc
        command: ["ls", "/nix/var/nix/profiles/system/specialisation"]

        stdout: StdioCollector {
            onStreamFinished: {
                const names = this.text.split("\n").map(function (name) {
                    return name.trim()
                }).filter(function (name) {
                    return name.length > 0
                })
                root.hasGamingSpecialisation = names.indexOf("gaming") !== -1
            }
        }
    }

    Process {
        id: activeSpecialisationProc
        command: ["cat", "/etc/specialisation"]

        stdout: StdioCollector {
            onStreamFinished: root.gamingActive = this.text.trim() === "gaming"
        }
    }

    Process {
        id: specialisationSwitchProc
    }

    Component.onCompleted: root.refresh()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!powerProfilePopup.visible)
                root.refresh()
            powerProfilePopup.visible = !powerProfilePopup.visible
        }
    }

    PopupWindow {
        id: powerProfilePopup
        anchor.item: root
        anchor.rect.y: root.height + 6
        anchor.rect.x: root.width / 2 - width / 2
        implicitWidth: 240
        implicitHeight: content.implicitHeight + 16
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
                id: content
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

                Rectangle {
                    visible: root.hasGamingSpecialisation
                    width: parent.width
                    height: 1
                    color: root.theme.surface
                }

                SelectorButton {
                    visible: root.hasGamingSpecialisation
                    width: parent.width
                    height: 36
                    theme: root.theme
                    active: root.gamingActive
                    text: "Gaming mode"
                    onClicked: root.switchGaming()
                }
            }
        }
    }
}
