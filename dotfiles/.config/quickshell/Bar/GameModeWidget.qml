import Quickshell
import Quickshell.Io
import QtQuick

Text {
    id: root

    required property var theme
    property bool active: false

    anchors.verticalCenter: parent.verticalCenter
    visible: active
    text: "GAME"
    color: theme.accent
    font.pixelSize: 12
    font.bold: true

    Process {
        id: statusProc
        command: ["gamemoded", "-s"]

        stdout: StdioCollector {
            onStreamFinished: root.active = /gamemode is active/i.test(this.text)
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: statusProc.running = true
    }

    Component.onCompleted: statusProc.running = true
}
