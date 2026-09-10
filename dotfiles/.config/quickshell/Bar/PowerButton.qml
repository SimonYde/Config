import QtQuick

Text {
    required property var theme
    required property var powerMenu
    anchors.verticalCenter: parent.verticalCenter
    text: ""
    color: theme.text
    font.pixelSize: 14

    MouseArea {
        anchors.fill: parent
        onClicked: parent.powerMenu.toggle()
    }
}
