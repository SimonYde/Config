import Quickshell
import QtQuick

Text {
    required property var theme
    anchors.verticalCenter: parent.verticalCenter
    text: Qt.formatDateTime(clock.date, "HH:mm")
    color: theme.text
    font.pixelSize: 14

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
