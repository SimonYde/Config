import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import qs.Common

PopupWindow {
    id: root

    required property var theme
    required property var media
    required property var audio
    required property var anchorItem

    readonly property alias caffeineActive: caffeine.active

    property bool switchingTheme: false

    property int temperature: 4000
    property int gamma: 100
    property bool nightLightEnabled: false
    property var commandQueue: []

    function applyTheme(state) {
        if (switchingTheme)
            return

        switchingTheme = true
        switchProc.command = [ "toggle-theme", state ]
        switchProc.running = true
    }

    function run(command) {
        commandQueue.push(command)
        if (!commandProc.running && !commandDispatchTimer.running)
            commandDispatchTimer.start()
    }

    function dispatchPendingCommand() {
        if (commandProc.running || commandQueue.length === 0)
            return

        const command = commandQueue.shift()
        commandProc.command = [ "hyprctl" ].concat(command)
        commandProc.running = true
    }

    function setTemperature(value) {
        temperature = Math.round(Math.max(1000, Math.min(7000, value)))
        run([ "hyprsunset", "temperature", String(temperature) ])
    }

    function setGamma(value) {
        gamma = Math.round(Math.max(50, Math.min(150, value)))
        run([ "hyprsunset", "gamma", String(gamma) ])
    }

    function setNightLight(enabled) {
        nightLightEnabled = enabled
        if (enabled) {
            run([ "hyprsunset", "temperature", String(temperature) ])
            run([ "hyprsunset", "gamma", String(gamma) ])
        } else {
            run([ "hyprsunset", "reset" ])
            profileSyncTimer.restart()
        }
    }

    function syncProfile() {
        profileProc.running = true
    }

    anchor.item: root.anchorItem
    anchor.rect.y: root.anchorItem.height + 6
    anchor.rect.x: root.anchorItem.width / 2 - root.width / 2
    implicitWidth: 450
    implicitHeight: overviewContent.implicitHeight + 20
    visible: false
    grabFocus: true
    color: "transparent"

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Process {
        id: switchProc
        onExited: root.switchingTheme = false
    }

    Process {
        id: commandProc

        onExited: {
            if (root.commandQueue.length > 0 && !commandDispatchTimer.running)
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
        command: [ "hyprctl", "hyprsunset", "profile" ]

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
                root.nightLightEnabled = root.temperature < 6000
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

    PopupSurface {
        theme: root.theme
        focus: root.visible
        anchors.fill: parent

        Keys.onEscapePressed: function (event) {
            root.visible = false
            event.accepted = true
        }

        Column {
            id: overviewContent
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Text {
                width: parent.width
                text: Qt.formatDateTime(clock.date, "dddd d. MMMM yyyy")
                color: root.theme.brightText
                font.pixelSize: 18
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Rectangle {
                width: parent.width
                height: 1
                color: root.theme.surface
            }

            Row {
                width: parent.width
                spacing: 12

                ClippingRectangle {
                    id: artFrame
                    width: 56
                    height: 56
                    radius: 8
                    color: root.theme.base

                    Image {
                        id: artImage
                        anchors.fill: parent
                        source: root.media.player ? root.media.player.trackArtUrl : ""
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        visible: status === Image.Ready
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: !artImage.visible
                        text: "\uf001"
                        color: root.theme.muted
                        font.pixelSize: 22
                    }
                }

                Column {
                    width: parent.width - artFrame.width - parent.spacing
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        width: parent.width
                        text: root.media.player
                            ? (root.media.player.trackTitle || "Unknown track")
                            : "No media playing"
                        color: root.theme.text
                        font.pixelSize: 15
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        visible: text !== ""
                        text: root.media.player ? root.media.player.trackArtist : ""
                        color: root.theme.muted
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        visible: text !== ""
                        text: root.media.player ? root.media.player.trackAlbum : ""
                        color: root.theme.muted
                        font.pixelSize: 12
                        elide: Text.ElideRight
                    }
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 28
                visible: !!root.media.player

                Text {
                    text: "\uf048"
                    color: prevMouse.containsMouse ? root.theme.accent : root.theme.text
                    font.pixelSize: 18

                    MouseArea {
                        id: prevMouse
                        anchors.fill: parent
                        anchors.margins: -6
                        hoverEnabled: true
                        onClicked: {
                            const p = root.media.player
                            if (p && p.canGoPrevious) {
                                root.media.activePlayer = p
                                p.previous()
                            }
                        }
                    }
                }

                Text {
                    text: root.media.player && root.media.player.isPlaying ? "\uf04c" : "\uf04b"
                    color: playMouse.containsMouse ? root.theme.accent : root.theme.text
                    font.pixelSize: 18

                    MouseArea {
                        id: playMouse
                        anchors.fill: parent
                        anchors.margins: -6
                        hoverEnabled: true
                        onClicked: {
                            const p = root.media.player
                            if (p && p.canTogglePlaying) {
                                root.media.activePlayer = p
                                p.togglePlaying()
                            }
                        }
                    }
                }

                Text {
                    text: "\uf051"
                    color: nextMouse.containsMouse ? root.theme.accent : root.theme.text
                    font.pixelSize: 18

                    MouseArea {
                        id: nextMouse
                        anchors.fill: parent
                        anchors.margins: -6
                        hoverEnabled: true
                        onClicked: {
                            const p = root.media.player
                            if (p && p.canGoNext) {
                                root.media.activePlayer = p
                                p.next()
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: root.theme.surface
            }

            Row {
                width: parent.width
                spacing: 8

                Text {
                    text: root.audio.muted ? "\uf026" : "\uf028"
                    color: root.theme.text
                    font.pixelSize: 14
                }

                Rectangle {
                    id: volumeTrack
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 96
                    height: 6
                    radius: height / 2
                    color: root.theme.base

                    Rectangle {
                        width: volumeTrack.width * Math.max(0, Math.min(1, root.audio.volume))
                        height: parent.height
                        radius: parent.radius
                        color: root.theme.accent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: function (mouse) {
                            updateVolume(mouse.x)
                        }
                        onPositionChanged: function (mouse) {
                            if (pressed)
                                updateVolume(mouse.x)
                        }

                        function updateVolume(position) {
                            if (root.audio.sink?.audio)
                                root.audio.sink.audio.volume = Math.max(0, Math.min(1, position / width))
                        }
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Math.round(root.audio.volume * 100) + "%"
                    color: root.theme.muted
                    font.pixelSize: 13
                }
            }

            Text {
                width: parent.width
                text: (root.audio.muted ? "Muted · " : "") + root.audio.sinkName
                color: root.theme.muted
                font.pixelSize: 12
                elide: Text.ElideRight
            }

            Rectangle {
                width: parent.width
                height: 1
                color: root.theme.surface
            }

            Row {
                width: parent.width
                spacing: 12

                Item {
                    width: (parent.width - parent.spacing * 2) / 3
                    height: 28

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.theme.isDark ? "\uf186" : "\uf185"
                            color: root.theme.text
                            font.pixelSize: 14
                        }

                        ToggleSwitch {
                            anchors.verticalCenter: parent.verticalCenter
                            theme: root.theme
                            checked: root.theme.isDark
                            onToggled: function (checked) {
                                root.applyTheme(checked ? "dark" : "light")
                            }
                        }
                    }
                }

                CaffeineWidget {
                    id: caffeine
                    width: (parent.width - parent.spacing * 2) / 3
                    theme: root.theme
                }

                Item {
                    width: (parent.width - parent.spacing * 2) / 3
                    height: 28

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "󰖔"
                            color: root.nightLightEnabled ? root.theme.base0A : root.theme.text
                            font.pixelSize: 14
                        }

                        ToggleSwitch {
                            anchors.verticalCenter: parent.verticalCenter
                            theme: root.theme
                            checked: root.nightLightEnabled
                            onToggled: function (checked) {
                                root.setNightLight(checked)
                            }
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing: 8
                visible: root.nightLightEnabled

                Item {
                    width: parent.width
                    height: 24

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
                    height: 24

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
            }
        }
    }
}
