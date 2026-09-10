import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

Row {
    id: root
    required property var bar
    required property var panel
    required property bool removableDeviceMounted
    anchors.verticalCenter: parent.verticalCenter
    spacing: 2

    Repeater {
        model: SystemTray.items

        delegate: Rectangle {
            id: trayItem
            required property var modelData
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
                        const position = mapToItem(root.bar, mouse.x, mouse.y)
                        modelData.display(root.panel, position.x, position.y)
                    } else {
                        modelData.activate()
                    }
                }
            }
        }
    }
}
