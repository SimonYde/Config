pragma Singleton
import Quickshell
import Quickshell.Services.Polkit
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Scope {
    id: root

    readonly property string authMessage: agent.flow ? agent.flow.message : "Authentication required"
    readonly property int commandSeparator: authMessage.indexOf(" to run ")
    readonly property bool hasCommand: commandSeparator >= 0
    readonly property string authPrompt: hasCommand ? authMessage.substring(0, commandSeparator + 8) : authMessage
    readonly property string authCommand: hasCommand ? authMessage.substring(commandSeparator + 8) : ""

    PolkitAgent {
        id: agent
    }

    PanelWindow {
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        focusable: agent.isActive
        visible: agent.isActive
        color: "transparent"
        onVisibleChanged: if (visible) response.forceActiveFocus()

        Rectangle {
            anchors.centerIn: parent
            width: 500
            height: content.implicitHeight + 32
            radius: 12
            color: Theme.background

            ColumnLayout {
                id: content
                anchors {
                    fill: parent
                    margins: 16
                }
                spacing: 10

                Text {
                    Layout.fillWidth: true
                    text: root.authPrompt
                    color: Theme.text
                    font.pixelSize: 16
                    font.bold: true
                    wrapMode: Text.WordWrap
                }

                Text {
                    Layout.fillWidth: true
                    text: root.authCommand
                    visible: root.hasCommand
                    color: Theme.text
                    font.pixelSize: 16
                    wrapMode: Text.WordWrap
                }

                Text {
                    Layout.fillWidth: true
                    text: agent.flow ? agent.flow.supplementaryMessage : ""
                    visible: text.length > 0
                    color: agent.flow && agent.flow.supplementaryIsError ? Theme.accent : Theme.muted
                    wrapMode: Text.WordWrap
                }

                TextField {
                    id: response
                    Layout.fillWidth: true
                    visible: agent.flow && agent.flow.isResponseRequired
                    echoMode: agent.flow && agent.flow.responseVisible ? TextInput.Normal : TextInput.Password
                    placeholderText: agent.flow ? agent.flow.inputPrompt : ""
                    color: Theme.text
                    placeholderTextColor: Theme.muted
                    selectionColor: Theme.accent
                    selectedTextColor: Theme.background
                    background: Rectangle {
                        color: Theme.base
                        border.color: response.activeFocus ? Theme.accent : Theme.muted
                        border.width: 1
                        radius: 4
                    }
                    onAccepted: submit()

                    function submit() {
                        if (agent.flow && text.length > 0) {
                            agent.flow.submit(text)
                            clear()
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight

                    Button {
                        id: cancelButton
                        text: "Cancel"
                        onClicked: if (agent.flow) agent.flow.cancelAuthenticationRequest()
                        background: Rectangle {
                            color: cancelButton.hovered ? Theme.accent : Theme.base
                            radius: 4
                        }
                        contentItem: Text {
                            text: cancelButton.text
                            color: cancelButton.hovered ? Theme.background : Theme.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Button {
                        id: authenticateButton
                        visible: response.visible
                        text: "Authenticate"
                        onClicked: response.submit()
                        background: Rectangle {
                            color: authenticateButton.hovered ? Theme.accent : Theme.base
                            radius: 4
                        }
                        contentItem: Text {
                            text: authenticateButton.text
                            color: authenticateButton.hovered ? Theme.background : Theme.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }
    }
}
