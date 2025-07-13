import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: sidebar
    width: 200
    height: parent.height
    color: "#f0f0f0"

    Column {
        spacing: 10
        anchors.fill: parent
        padding: 10

        Text {
            text: "Folders"
            font.bold: true
            font.pointSize: 16
        }

        ListView {
            id: folderListView
            model: folderModel // This should be provided by the parent component
            delegate: Item {
                width: sidebar.width
                height: 40

                Rectangle {
                    anchors.fill: parent
                    color: mouseArea.containsMouse ? "#d0d0d0" : "transparent"
                    border.color: "gray"
                    border.width: 1
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: model.folderName // Assuming folderName is a property in the model
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            // Logic to change the current folder in the main view
                            folderModel.changeFolder(model.folderPath) // Assuming changeFolder is a method in the model
                        }
                    }
                }
            }
        }
    }
}