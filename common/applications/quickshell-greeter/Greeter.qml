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
    screen: Quickshell.screens[0]
    color: Theme.background

    property string username: ""
    property string password: ""
    property string message: ""
    property var sessions: []
    property int sessionIndex: 0

    // Session desktop files are looked up in the usual session directories,
    // with per-user profiles first so user-installed sessions take precedence.
    // The greeter runs before login, so the target user's profile is unknown;
    // scanning all per-user profiles is harmless because they only provide
    // session entries.
    readonly property string sessionScanScript: `
for dir in \
    /etc/profiles/per-user/*/share/wayland-sessions \
    /etc/profiles/per-user/*/share/xsessions \
    /run/current-system/sw/share/wayland-sessions \
    /run/current-system/sw/share/xsessions \
    /usr/local/share/wayland-sessions \
    /usr/local/share/xsessions \
    /usr/share/wayland-sessions \
    /usr/share/xsessions \
    "$HOME/.local/share/wayland-sessions" \
    "$HOME/.local/share/xsessions"
do
    [ -d "$dir" ] || continue
    for file in "$dir"/*.desktop
    do
        [ -f "$file" ] || continue
        printf '\\n@@SESSION@@%s\\n' "$file"
        cat "$file"
    done
done
`

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
        SystemClock {
            id: clock
            precision: SystemClock.Seconds
        }

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

        Text {
            text: "Session"
            color: Theme.muted
            font.pixelSize: 12
        }

        ComboBox {
            id: sessionField
            width: parent.width
            height: 44
            focusPolicy: Qt.StrongFocus
            model: root.sessions
            textRole: "name"
            currentIndex: root.sessionIndex
            onActivated: function(index) {
                root.sessionIndex = index
            }
            background: Rectangle {
                color: Theme.base
                border.color: sessionField.activeFocus ? Theme.accent : Theme.muted
                border.width: sessionField.activeFocus ? 2 : 1
                radius: 4
            }
            contentItem: Text {
                leftPadding: 12
                rightPadding: 32
                text: sessionField.displayText
                color: Theme.text
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            indicator: Text {
                x: sessionField.width - width - sessionField.rightPadding
                y: sessionField.topPadding + (sessionField.availableHeight - height) / 2
                text: "\u25be"
                color: Theme.muted
            }
            delegate: ItemDelegate {
                id: sessionDelegate
                required property var model
                required property int index
                width: sessionField.width
                height: 40
                text: model[sessionField.textRole]
                highlighted: sessionField.highlightedIndex === index
                contentItem: Text {
                    leftPadding: 12
                    rightPadding: 12
                    text: sessionDelegate.text
                    color: sessionDelegate.highlighted ? Theme.background : Theme.text
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    color: sessionDelegate.highlighted ? Theme.accent : "transparent"
                    radius: 3
                }
            }
            popup: Popup {
                y: sessionField.height + 2
                width: sessionField.width
                padding: 1
                contentItem: ListView {
                    clip: true
                    implicitHeight: Math.min(contentHeight, 6 * 40)
                    model: sessionField.popup.visible ? sessionField.delegateModel : null
                    currentIndex: sessionField.highlightedIndex
                    ScrollIndicator.vertical: ScrollIndicator {}
                }
                background: Rectangle {
                    color: Theme.base
                    border.color: Theme.muted
                    radius: 4
                }
            }
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

    Process {
        id: sessionScan
        command: [ "sh", "-c", root.sessionScanScript ]
        stdout: StdioCollector {
            onStreamFinished: root.parseSessions(this.text)
        }
    }

    Component.onCompleted: sessionScan.running = true

    function runCmd(cmd) {
        cmdProc.command = [ "sh", "-c", cmd ]
        cmdProc.running = true
    }

    function parseSessions(raw) {
        const entries = []
        const seen = new Set()

        for (const chunk of raw.split("@@SESSION@@").slice(1)) {
            const headerEnd = chunk.indexOf("\n")
            if (headerEnd < 0)
                continue

            const path = chunk.substring(0, headerEnd).trim()
            const id = path.split("/").pop()
            if (seen.has(id))
                continue

            const body = chunk.substring(headerEnd + 1)
            let name = ""
            let exec = ""
            let hidden = false

            for (const line of body.split("\n")) {
                const text = line.trim()
                if (text.startsWith("Name="))
                    name = text.substring(5)
                else if (text.startsWith("Exec="))
                    exec = text.substring(5)
                else if (text === "NoDisplay=true" || text === "Hidden=true")
                    hidden = true
            }

            if (hidden || name === "" || exec === "")
                continue

            seen.add(id)
            entries.push({
                id: id,
                name: name,
                exec: exec
            })
        }

        if (entries.length === 0) {
            // Keep the previous behavior as a fallback if discovery fails.
            entries.push({
                id: "hyprland-uwsm.desktop",
                name: "Hyprland (uwsm-managed)",
                exec: "uwsm start hyprland-uwsm.desktop"
            })
        }

        sessions = entries

        let preferred = 0
        for (let i = 0; i < entries.length; i++) {
            if (entries[i].id === "hyprland-uwsm.desktop") {
                preferred = i
                break
            }
        }
        sessionIndex = preferred
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
            if (sessions.length === 0) {
                return
            }

            const session = sessions[Math.max(0, Math.min(sessionIndex, sessions.length - 1))]

            // Run the entry's Exec line through the shell so quoted arguments
            // and environment assignments work.
            Greetd.launch([ "sh", "-c", session.exec ])
        }
    }
}
