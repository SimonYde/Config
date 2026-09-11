import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    signal unlocked()

    property string password: ""
    property bool authenticating: false
    property bool failed: false
    readonly property string message: pam.message

    onPasswordChanged: failed = false

    Component.onCompleted: authenticate()

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
