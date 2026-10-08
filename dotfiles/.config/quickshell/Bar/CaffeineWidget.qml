import Quickshell
import Quickshell.Io
import QtQuick
import qs.Common

Item {
    id: root

    required property var theme
    property bool active: false

    implicitHeight: 28

    Row {
        anchors.centerIn: parent
        spacing: 8

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "󰅶"
            color: root.active ? root.theme.base0A : root.theme.text
            font.pixelSize: 16
        }

        ToggleSwitch {
            anchors.verticalCenter: parent.verticalCenter
            theme: root.theme
            checked: root.active
            onToggled: function (checked) {
                root.active = checked
            }
        }
    }

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
}
