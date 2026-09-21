//@ pragma UseQApplication

import Quickshell
import QtQuick
import "Bar"

ShellRoot {
    id: root

    Bar {
        theme: Theme
        audio: Audio
        media: Media
        notifications: Notifications
        controlCenter: ControlCenter
        powerMenu: PowerMenu
    }
    Shortcuts {}

    // Force creation of the singleton shells (they own windows / servers).
    QtObject {
        readonly property var _osd: Osd
        readonly property var _controlCenter: ControlCenter
        readonly property var _powerMenu: PowerMenu
        readonly property var _notificationPopup: NotificationPopup
        readonly property var _polkit: Polkit
        readonly property var _notifications: Notifications
        readonly property var _audio: Audio
        readonly property var _brightness: Brightness
        readonly property var _media: Media
    }
}
