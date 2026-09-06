import Quickshell
import Quickshell.Io
import Quickshell.Services.Greetd
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

FloatingWindow {
    id: root

    visible: true
    fullscreen: true
    color: Theme.background

    property string username: ""
    property string password: ""
    property string message: ""

    Rectangle {
        anchors.fill: parent
        color: Theme.background

        Image {
            anchors.fill: parent
            source: "/var/lib/quickshell-greeter/current-wallpaper"
            fillMode: Image.PreserveAspectCrop
            opacity: 0.55
        }
    }

    Column {
        anchors.centerIn: parent
        width: 360
        spacing: 12

        Text {
            text: Qt.formatDateTime(SystemClock.date, "HH:mm")
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 64
            color: Theme.text
        }

        TextField {
            id: userField
            width: parent.width
            height: 44
            focusPolicy: Qt.StrongFocus
            placeholderText: "Username"
            color: Theme.text
            placeholderTextColor: Theme.muted
            selectionColor: Theme.accent
            selectedTextColor: Theme.background
            cursorDelegate: Rectangle {
                width: 1
                color: Theme.accent
            }
            background: Rectangle {
                color: Theme.base
                border.color: userField.activeFocus ? Theme.accent : Theme.muted
                border.width: userField.activeFocus ? 2 : 1
                radius: 4
            }
            text: root.username
            onTextChanged: root.username = text
            onAccepted: root.submit()
        }

        TextField {
            id: passField
            width: parent.width
            height: 44
            focusPolicy: Qt.StrongFocus
            placeholderText: "Password"
            color: Theme.text
            placeholderTextColor: Theme.muted
            selectionColor: Theme.accent
            selectedTextColor: Theme.background
            cursorDelegate: Rectangle {
                width: 1
                color: Theme.accent
            }
            background: Rectangle {
                color: Theme.base
                border.color: passField.activeFocus ? Theme.accent : Theme.muted
                border.width: passField.activeFocus ? 2 : 1
                radius: 4
            }
            echoMode: TextInput.Password
            text: root.password
            onTextChanged: root.password = text
            onAccepted: root.submit()
        }

        Button {
            id: loginButton
            width: parent.width
            height: 44
            focusPolicy: Qt.StrongFocus
            text: "Login"
            background: Rectangle {
                color: loginButton.hovered || loginButton.activeFocus ? Theme.accent : Theme.base
                border.color: loginButton.activeFocus ? Theme.text : "transparent"
                border.width: loginButton.activeFocus ? 2 : 0
                radius: 4
            }
            contentItem: Text {
                text: loginButton.text
                color: loginButton.hovered || loginButton.activeFocus ? Theme.background : Theme.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: root.submit()
            Keys.onReturnPressed: root.submit()
            Keys.onEnterPressed: root.submit()
        }

        Text {
            text: root.message
            color: Theme.accent
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Row {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 24
        }
        spacing: 12

        Button {
            id: rebootButton
            focusPolicy: Qt.StrongFocus
            text: "Reboot"
            background: Rectangle {
                color: rebootButton.hovered || rebootButton.activeFocus ? Theme.accent : Theme.base
                border.color: rebootButton.activeFocus ? Theme.text : "transparent"
                border.width: rebootButton.activeFocus ? 2 : 0
                radius: 4
            }
            contentItem: Text {
                text: rebootButton.text
                color: rebootButton.hovered || rebootButton.activeFocus ? Theme.background : Theme.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: runCmd("systemctl reboot")
            Keys.onReturnPressed: runCmd("systemctl reboot")
            Keys.onEnterPressed: runCmd("systemctl reboot")
        }
        Button {
            id: poweroffButton
            focusPolicy: Qt.StrongFocus
            text: "Poweroff"
            background: Rectangle {
                color: poweroffButton.hovered || poweroffButton.activeFocus ? Theme.accent : Theme.base
                border.color: poweroffButton.activeFocus ? Theme.text : "transparent"
                border.width: poweroffButton.activeFocus ? 2 : 0
                radius: 4
            }
            contentItem: Text {
                text: poweroffButton.text
                color: poweroffButton.hovered || poweroffButton.activeFocus ? Theme.background : Theme.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: runCmd("systemctl poweroff")
            Keys.onReturnPressed: runCmd("systemctl poweroff")
            Keys.onEnterPressed: runCmd("systemctl poweroff")
        }
    }

    Process {
        id: cmdProc
    }

    function runCmd(cmd) {
        cmdProc.command = [ "sh", "-c", cmd ]
        cmdProc.running = true
    }

    function submit() {
        message = ""
        if (username === "") {
            message = "Enter a username"
            return
        }
        Greetd.createSession(username)
    }

    Connections {
        target: Greetd

        function onAuthMessage(msg, error, responseRequired, echoResponse) {
            message = msg
            if (responseRequired) {
                if (echoResponse) {
                    Greetd.respond(username)
                } else {
                    Greetd.respond(password)
                }
            }
        }

        function onAuthFailure(msg) {
            message = msg
        }

        function onReadyToLaunch() {
            // Keep the direct argv handoff required by greetd/UWSM, while
            // suppressing UWSM's normal startup messages.
            Greetd.launch([
                "env", "UWSM_SILENT_START=2", "uwsm", "start",
                "hyprland-uwsm.desktop",
            ])
        }
    }
}
