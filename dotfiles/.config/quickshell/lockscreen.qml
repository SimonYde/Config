import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    LockContext {
        id: context
    }

    WlSessionLock {
        id: lock
        locked: true

        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                authContext: context
            }
        }
    }

    Connections {
        target: context

        function onUnlocked() {
            lock.locked = false
            Qt.quit()
        }
    }
}
