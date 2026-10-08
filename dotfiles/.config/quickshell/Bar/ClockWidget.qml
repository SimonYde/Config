import Quickshell
import QtQuick

Rectangle {
    id: root

    required property var theme
    required property var media
    required property var audio

    readonly property bool caffeineActive: overviewPopup.caffeineActive

    implicitWidth: clockRow.implicitWidth + 20
    implicitHeight: 24
    color: theme.background
    radius: 8
    border.color: theme.accent
    border.width: 1

    Row {
        id: clockRow
        anchors.centerIn: parent
        spacing: 4

        Text {
            id: caffeineIndicator
            anchors.verticalCenter: parent.verticalCenter
            visible: root.caffeineActive
            text: "󰅶"
            color: root.theme.base0A
            font.pixelSize: 12
        }

        Text {
            id: clockText
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatDateTime(clock.date, "HH:mm")
            color: root.theme.text
            font.pixelSize: 14
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    MouseArea {
        anchors.fill: parent
        onClicked: overviewPopup.visible = !overviewPopup.visible
    }

    ClockPopup {
        id: overviewPopup
        anchorItem: root
        theme: root.theme
        media: root.media
        audio: root.audio
    }
}
