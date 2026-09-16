import Quickshell
import Quickshell.Io
import QtQuick

Text {
    id: root

    required property var theme
    property bool active: false

    anchors.verticalCenter: parent.verticalCenter
    text: "󰅶"
    color: active ? theme.base0A : theme.text
    font.pixelSize: 16

    Process {
        id: inhibitorProc
        command: [
            "systemd-inhibit",
            "--what=idle:sleep",
            "--who=Quickshell",
            "--why=Caffeine mode",
            "--mode=block",
            "sleep",
            "infinity"
        ]
        running: root.active

        onExited: root.active = false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.active = !root.active
    }
}
