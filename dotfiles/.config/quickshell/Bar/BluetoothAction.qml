import QtQuick

Rectangle {
    required property string text
    required property bool active
    required property var theme
    signal clicked()

    height: 28
    radius: 6
    color: active ? theme.accent : theme.base

    Text {
        anchors.centerIn: parent
        text: parent.text
        color: parent.active ? parent.theme.background : parent.theme.text
        font.pixelSize: 12
    }

    MouseArea {
        anchors.fill: parent
        enabled: parent.enabled
        onClicked: parent.clicked()
    }
}
