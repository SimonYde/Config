import QtQuick

Text {
    required property var theme
    required property var notifications
    required property var controlCenter
    anchors.verticalCenter: parent.verticalCenter
    text: (notifications.doNotDisturb ? "" : "")
        + (notifications.count > 0 ? " " + notifications.count : "")
    color: theme.text
    font.pixelSize: 14

    MouseArea {
        anchors.fill: parent
        onClicked: parent.controlCenter.toggle()
    }
}
