import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#000000"

    Rectangle {
        id: panel
        width: 420
        height: 280
        radius: 18

        color: "#0d0f10"
        border.color: "#5fd4e6"
        border.width: 1

        anchors.centerIn: parent

        opacity: 0
        scale: 0.95

        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }
        Behavior on scale {
            NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
        }

        Behavior on border.color {
            ColorAnimation { duration: 300 }
        }

        Component.onCompleted: {
            opacity = 1
            scale = 1
        }

        layer.enabled: true
        layer.effect: DropShadow {
            color: "#5fd4e6"
            radius: 18
            samples: 16
            spread: 0.05
        }

        Column {
            anchors.centerIn: parent
            spacing: 16
            width: parent.width

            Text {
                text: Qt.formatTime(new Date(), "hh:mm")

                font.family: "Inter"
                font.pixelSize: 72
                font.weight: Font.DemiBold

                color: "white"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            Text {
                text: Qt.formatDate(new Date(), "dddd, dd MMMM")

                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.Light

                color: "white"
                opacity: 0.6

                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            Text {
                text: userModel.lastUser

                font.family: "Inter"
                font.pixelSize: 20
                font.weight: Font.Medium

                color: "white"
                opacity: 0.85

                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            TextField {
                id: passwordField
                width: 240
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter

                echoMode: TextInput.Password
                placeholderText: "Enter Password..."

                font.family: "Inter"
                font.pixelSize: 14

                color: "white"
                placeholderTextColor: "#aaaaaa"

                focus: true
                Component.onCompleted: forceActiveFocus()

                background: Rectangle {
                    radius: 10
                    border.color: "#5fd4e6"
                    border.width: 1.5
                    color: "#111111"
                }

                onAccepted: sddm.login(userModel.lastUser, text, sessionModel.lastIndex)
            }
        }
    }
}
