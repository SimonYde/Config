pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root

    readonly property int percent: _percent
    property int _percent: 0

    function refresh() {
        getProc.running = true
    }

    function adjust(delta) {
        const adjustment = delta > 0 ? "+" + delta + "%" : Math.abs(delta) + "%-"
        setProc.command = [ "brightnessctl", "set", adjustment ]
        setProc.running = true
        delay.restart()
    }

    Timer {
        id: delay
        interval: 250
        onTriggered: root.refresh()
    }

    Process {
        id: setProc
    }

    Process {
        id: getProc
        command: [ "brightnessctl", "-m" ]
        stdout: StdioCollector {
            onStreamFinished: {
                const m = this.text.match(/(\d+)%/)
                if (m) {
                    root._percent = parseInt(m[1])
                }
            }
        }
    }

    Component.onCompleted: refresh()
}
