import Quickshell
import Quickshell.Io
import QtQuick
import qs.Common

Text {
    id: root

    required property var theme
    property int temperature: 4000
    property int gamma: 100
    property var pendingCommand: null

    anchors.verticalCenter: parent.verticalCenter
    text: "󰖔"
    color: theme.text
    font.pixelSize: 16

    function run(command) {
        pendingCommand = command
        if (!commandDispatchTimer.running)
            commandDispatchTimer.start()
    }

    function dispatchPendingCommand() {
        if (commandProc.running || pendingCommand === null)
            return

        const command = pendingCommand
        pendingCommand = null
        commandProc.command = ["hyprctl"].concat(command)
        commandProc.running = true
    }

    function setTemperature(value) {
        temperature = Math.round(Math.max(1000, Math.min(7000, value)))
        run(["hyprsunset", "temperature", String(temperature)])
    }

    function setGamma(value) {
        gamma = Math.round(Math.max(50, Math.min(150, value)))
        run(["hyprsunset", "gamma", String(gamma)])
    }

    function syncProfile() {
        profileProc.running = true
    }

    Process {
        id: commandProc

        onExited: {
            if (root.pendingCommand !== null && !commandDispatchTimer.running)
                commandDispatchTimer.start()
        }
    }

    Timer {
        id: commandDispatchTimer
        interval: 25
        repeat: false
        onTriggered: root.dispatchPendingCommand()
    }

    Process {
        id: profileProc
        command: ["hyprctl", "hyprsunset", "profile"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text
                const temperatureMatch = output.match(/temperature\s*[:=]\s*(\d+)/i)
                const gammaMatch = output.match(/gamma\s*[:=]\s*([0-9.]+)/i)

                // Profiles may omit values when using their defaults.
                root.temperature = temperatureMatch
                    ? Math.round(Math.max(1000, Math.min(7000, Number(temperatureMatch[1]))))
                    : 6000
                root.gamma = gammaMatch
                    ? Math.round(Math.max(50, Math.min(150,
                        Number(gammaMatch[1]) <= 2 ? Number(gammaMatch[1]) * 100 : Number(gammaMatch[1]))))
                    : 100
            }
        }
    }

    Timer {
        id: profileSyncTimer
        interval: 100
        repeat: false
        onTriggered: root.syncProfile()
    }

    Component.onCompleted: root.syncProfile()

    MouseArea {
        anchors.fill: parent
        onClicked: sunsetPopup.visible = !sunsetPopup.visible
    }

    PopupWindow {
        id: sunsetPopup
        anchor.item: root
        anchor.rect.y: root.height + 6
        anchor.rect.x: root.width / 2 - width / 2
        implicitWidth: 270
        implicitHeight: 184
        visible: false
        grabFocus: true
        color: "transparent"

        PopupSurface {
            theme: root.theme
            focus: sunsetPopup.visible
            anchors.fill: parent

            Keys.onEscapePressed: function (event) {
                sunsetPopup.visible = false
                event.accepted = true
            }

            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Text {
                    width: parent.width
                    text: "Night light"
                    color: root.theme.text
                    font.pixelSize: 14
                }

                Item {
                    width: parent.width
                    height: 34

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 58
                        text: root.temperature + "K"
                        color: root.theme.text
                        font.pixelSize: 12
                    }

                    Rectangle {
                        id: temperatureTrack
                        anchors.left: parent.left
                        anchors.leftMargin: 66
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: 6
                        radius: height / 2
                        color: root.theme.base

                        Rectangle {
                            width: temperatureTrack.width * (root.temperature - 1000) / (7000 - 1000)
                            height: parent.height
                            radius: parent.radius
                            color: root.theme.accent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: function (mouse) {
                                updateTemperature(mouse.x)
                            }
                            onPositionChanged: function (mouse) {
                                if (pressed)
                                    updateTemperature(mouse.x)
                            }

                            function updateTemperature(position) {
                                root.setTemperature(1000 + (position / width) * (7000 - 1000))
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: 34

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 58
                        text: root.gamma + "%"
                        color: root.theme.text
                        font.pixelSize: 12
                    }

                    Rectangle {
                        id: gammaTrack
                        anchors.left: parent.left
                        anchors.leftMargin: 66
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: 6
                        radius: height / 2
                        color: root.theme.base

                        Rectangle {
                            width: gammaTrack.width * (root.gamma - 50) / (150 - 50)
                            height: parent.height
                            radius: parent.radius
                            color: root.theme.accent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPressed: function (mouse) {
                                updateGamma(mouse.x)
                            }
                            onPositionChanged: function (mouse) {
                                if (pressed)
                                    updateGamma(mouse.x)
                            }

                            function updateGamma(position) {
                                root.setGamma(50 + (position / width) * (150 - 50))
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 30
                    radius: 6
                    color: root.theme.base

                    Text {
                        anchors.centerIn: parent
                        text: "Reset to profile"
                        color: root.theme.text
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.run(["hyprsunset", "reset"])
                            profileSyncTimer.restart()
                            sunsetPopup.visible = false
                        }
                    }
                }
            }
        }
    }
}
