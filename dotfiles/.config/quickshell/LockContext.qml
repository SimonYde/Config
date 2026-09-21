import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam

Scope {
    id: root

    signal unlocked()

    property string password: ""
    property bool authenticating: false
    property bool failed: false
    readonly property string message: pam.message

    onPasswordChanged: failed = false

    Process {
        id: fprintdCheck
        command: [ "sh", "-c", "command -v fprintd-verify" ]
        onExited: function (code) {
            if (code === 0)
                root.authenticate()
        }
    }

    // Only start authentication automatically when fprintd is available, so the
    // fingerprint prompt can be triggered. Otherwise wait for the user to press
    // Enter, which starts PAM with the typed password.
    Component.onCompleted: fprintdCheck.running = true

    function authenticate() {
        if (authenticating)
            return

        authenticating = pam.start()
    }

    PamContext {
        id: pam

        config: "quickshell"

        onResponseRequiredChanged: {
            if (responseRequired)
                respond(root.password)
        }

        onCompleted: result => {
            root.authenticating = false

            if (result === PamResult.Success) {
                root.unlocked()
                return
            }

            root.password = ""
            root.failed = true
        }
    }
}
