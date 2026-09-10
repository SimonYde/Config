import Quickshell.Hyprland
import QtQuick

Row {
    id: root
    required property var monitor
    required property var theme
    spacing: 4

    Repeater {
        model: Hyprland.workspaces.values.filter(function (workspace) {
            return !workspace.name.startsWith("special:")
                && workspace.monitor?.name === root.monitor.name
        })

        delegate: Rectangle {
            width: 24
            height: 24
            radius: 6
            color: modelData.focused ? root.theme.accent : "transparent"

            Text {
                anchors.centerIn: parent
                text: modelData.name
                color: modelData.focused ? root.theme.background : root.theme.text
                font.pixelSize: 12
            }

            MouseArea {
                anchors.fill: parent
                onClicked: modelData.activate()
            }
        }
    }
}
