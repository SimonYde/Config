import QtQuick

Rectangle {
    required property var theme

    color: theme.background
    radius: 10
    border.color: theme.accent
    border.width: 1
}
