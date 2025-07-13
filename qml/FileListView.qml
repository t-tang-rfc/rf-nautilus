import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ListView {
    id: fileListView
    anchors.fill: parent
    spacing: 5
    clip: true

    model: fileModel // This should be set to the model that provides file and folder data

    delegate: Item {
        width: fileListView.width
        height: 50 // Adjust height as needed

        RowLayout {
            anchors.fill: parent
            spacing: 10

            FolderItem {
                visible: model.type === "folder"
                folderName: model.fileName
                onClicked: {
                    // Handle folder selection
                }
            }

            FileItem {
                visible: model.type === "file"
                fileName: model.fileName
                onClicked: {
                    // Handle file selection
                }
            }
        }
    }

    // Optional: Add a custom scrollbar if needed
    ScrollBar.vertical: ScrollBar {
        id: verticalScrollBar
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
}