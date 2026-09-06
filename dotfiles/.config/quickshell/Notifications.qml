pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Scope {
    id: root

    property bool doNotDisturb: false
    readonly property int count: server.trackedNotifications.values.length
    readonly property var notifications: server.trackedNotifications
    readonly property var groupedNotifications: {
        const groups = []
        const groupsByName = Object.create(null)

        for (const notification of server.trackedNotifications.values) {
            const appName = notification.appName || "Unknown application"
            if (!groupsByName[appName]) {
                groupsByName[appName] = {
                    appName: appName,
                    notifications: [],
                }
                groups.push(groupsByName[appName])
            }
            groupsByName[appName].notifications.push(notification)
        }

        return groups
    }
    signal notificationReceived(var notification)

    NotificationServer {
        id: server
        actionsSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true
        inlineReplySupported: true
        onNotification: function (n) {
            n.tracked = true
            root.notificationReceived(n)
        }
    }

    function closeAll() {
        const notifications = server.trackedNotifications.values.slice()
        for (const notification of notifications) {
            notification.dismiss()
        }
    }
}
