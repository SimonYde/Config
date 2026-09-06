//@ pragma UseQApplication

import Quickshell
import QtQuick

ShellRoot {
    id: root

    Bar {}
    Shortcuts {}

    // Force creation of the singleton shells (they own windows / servers).
    QtObject {
        readonly property var _osd: Osd
        readonly property var _controlCenter: ControlCenter
        readonly property var _powerMenu: PowerMenu
        readonly property var _notificationPopup: NotificationPopup
        readonly property var _notifications: Notifications
        readonly property var _audio: Audio
        readonly property var _brightness: Brightness
    }
}
