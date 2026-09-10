import QtQuick

Rectangle {
    id: root

    required property string text
    required property bool active
    required property var theme
    signal clicked()

    implicitWidth: label.implicitWidth + 20
    implicitHeight: 28
    radius: 6
    color: root.active ? root.theme.accent : root.theme.base
    opacity: root.enabled ? 1 : 0.5

    Text {
        id: label
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        text: root.text
        color: root.active ? root.theme.background : root.theme.text
        font.pixelSize: 12
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        onClicked: root.clicked()
    }
}
