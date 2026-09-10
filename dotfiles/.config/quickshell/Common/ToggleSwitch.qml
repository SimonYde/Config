import QtQuick

Item {
    id: root

    required property bool checked
    required property var theme
    property color checkedColor: root.theme.accent
    signal toggled(bool checked)

    implicitWidth: 40
    implicitHeight: 24
    opacity: root.enabled ? 1 : 0.5

    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: root.checked ? root.checkedColor : root.theme.base
        border.color: root.checked ? root.checkedColor : root.theme.muted
        border.width: 1

        Rectangle {
            id: knob
            width: track.height - 6
            height: width
            radius: width / 2
            anchors.verticalCenter: parent.verticalCenter
            x: root.checked ? track.width - width - 3 : 3
            color: root.checked ? root.theme.background : root.theme.text

            Behavior on x {
                NumberAnimation {
                    duration: 140
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled(!root.checked)
    }
}
