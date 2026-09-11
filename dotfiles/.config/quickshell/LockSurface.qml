import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root

    required property LockContext authContext

    Rectangle {
        anchors.fill: parent
        color: Theme.background

        Image {
            anchors.fill: parent
            source: "file://" + Quickshell.env("XDG_RUNTIME_DIR") + "/current-wallpaper"
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            opacity: 0.35
        }

        Rectangle {
            anchors.fill: parent
            color: Theme.background
            opacity: 0.72
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: Math.min(parent.width - 48, 420)
            spacing: 14

            Text {
                id: clock
                Layout.fillWidth: true
                text: Qt.formatDateTime(systemClock.date, "HH:mm")
                color: Theme.text
                font.pixelSize: 72
                font.bold: true
                horizontalAlignment: Text.AlignHCenter

                SystemClock {
                    id: systemClock
                    precision: SystemClock.Seconds
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.authContext.failed ? "Authentication failed" : "Session locked"
                color: root.authContext.failed ? Theme.accent : Theme.muted
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
            }

            TextField {
                id: password
                Layout.fillWidth: true
                focus: true
                enabled: !root.authContext.authenticating
                echoMode: TextInput.Password
                placeholderText: "Password"
                color: Theme.text
                placeholderTextColor: Theme.muted
                selectionColor: Theme.accent
                selectedTextColor: Theme.background
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhSensitiveData
                background: Rectangle {
                    color: Theme.base
                    border.color: password.activeFocus ? Theme.accent : Theme.muted
                    border.width: 1
                    radius: 8
                }

                onTextChanged: root.authContext.password = text
                onAccepted: root.authContext.authenticate()
                Keys.onPressed: function (event) {
                    if (event.key !== Qt.Key_Return && event.key !== Qt.Key_Enter)
                        return

                    root.authContext.authenticate()
                    event.accepted = true
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.authContext.authenticating ? "Authenticating..." : root.authContext.message
                visible: text.length > 0 || root.authContext.authenticating
                color: Theme.muted
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Connections {
        target: root.authContext

        function onPasswordChanged() {
            if (password.text !== root.authContext.password)
                password.text = root.authContext.password
        }
    }
}
