import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Scope {
    id: root

    GlobalShortcut {
        appid: "quickshell"
        name: "power-menu"
        onPressed: PowerMenu.toggle()
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "volume-up"
        onPressed: Audio.adjustVolume(0.1)
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "volume-down"
        onPressed: Audio.adjustVolume(-0.1)
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "volume-mute"
        onPressed: Audio.toggleMute()
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "mic-mute"
        onPressed: Audio.toggleMicMute()
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "brightness-up"
        onPressed: {
            Brightness.adjust(10)
            Osd.show("brightness")
        }
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "brightness-down"
        onPressed: {
            Brightness.adjust(-10)
            Osd.show("brightness")
        }
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "media-play-pause"
        onPressed: media("play-pause")
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "media-next"
        onPressed: media("next")
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "media-prev"
        onPressed: media("prev")
    }

    Process {
        id: mediaProc
    }

    function media(action) {
        mediaProc.command = [ "playerctl", action ]
        mediaProc.running = true
        Osd.show("media")
    }
}
