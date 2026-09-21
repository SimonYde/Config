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
            notificationBody: notification.body ?? "",
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
        implicitHeight: notificationList.contentHeight
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        aboveWindows: true
        color: "transparent"
        visible: false

        ListView {
            id: notificationList
            anchors.fill: parent
            spacing: 8
            interactive: false
            model: popupModel

            delegate: Rectangle {
                required property int popupId
                required property string appIcon
                required property string appName
                required property string summary
                required property string notificationBody

                width: ListView.view.width
                height: Math.max(body.implicitHeight + 24, 56)
                color: Qt.rgba(Theme.base.r, Theme.base.g, Theme.base.b, 0.92)
                radius: 12
                border.color: Theme.accent
                border.width: 1

                Timer {
                    interval: 4000
                    running: true
                    onTriggered: root.removePopup(popupId)
                }

                IconImage {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 12
                    anchors.topMargin: 12
                    width: 32
                    height: 32
                    source: appIcon
                }

                Column {
                    id: body
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: appIcon ? 56 : 12
                    anchors.rightMargin: 12
                    anchors.topMargin: 12
                    spacing: 2

                    Text {
                        width: parent.width
                        text: appName
                        color: Theme.muted
                        font.pixelSize: 12
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        text: summary
                        color: Theme.text
                        font.pixelSize: 16
                        font.bold: true
                        wrapMode: Text.Wrap
                    }

                    Text {
                        width: parent.width
                        text: notificationBody
                        color: Theme.text
                        wrapMode: Text.Wrap
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
