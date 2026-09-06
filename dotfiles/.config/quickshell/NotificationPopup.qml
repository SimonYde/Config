pragma Singleton
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick

Scope {
    id: root

    property int nextPopupId: 0

    ListModel {
        id: popupModel
    }

    function addPopup(notification) {
        popupModel.append({
            popupId: nextPopupId++,
            appIcon: notification.appIcon ?? "",
            appName: notification.appName,
            summary: notification.summary,
        })
        popup.visible = true
    }

    function removePopup(popupId) {
        for (let i = 0; i < popupModel.count; i++) {
            if (popupModel.get(i).popupId === popupId) {
                popupModel.remove(i)
                break
            }
        }
        if (popupModel.count === 0) {
            popup.visible = false
        }
    }

    Connections {
        target: Notifications
        function onNotificationReceived(notification) {
            root.addPopup(notification)
        }
    }

    PanelWindow {
        id: popup
        anchors {
            top: true
            right: true
        }
        margins {
            top: 44
            right: 4
        }
        implicitWidth: 360
        implicitHeight: popupModel.count * 140 + Math.max(0, popupModel.count - 1) * 8
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        aboveWindows: true
        color: "transparent"
        visible: false

        ListView {
            anchors.fill: parent
            spacing: 8
            interactive: false
            model: popupModel

            delegate: Rectangle {
                required property int popupId
                required property string appIcon
                required property string appName
                required property string summary

                width: ListView.view.width
                height: 140
                color: Qt.rgba(Theme.base.r, Theme.base.g, Theme.base.b, 0.92)
                radius: 12

                Timer {
                    interval: 4000
                    running: true
                    onTriggered: root.removePopup(popupId)
                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4

                    IconImage {
                        width: 32
                        height: 32
                        source: appIcon
                    }

                    Column {
                        width: parent.width - 36
                        spacing: 4

                        Text {
                            text: appName
                            color: Theme.muted
                            font.pixelSize: 12
                        }

                        Text {
                            text: summary
                            color: Theme.text
                            font.pixelSize: 16
                            font.bold: true
                            wrapMode: Text.Wrap
                            width: parent.width
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.removePopup(popupId)
                }
            }
        }
    }
}
