import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 600
    title: "Custom File Dialog"

    FileDialog {
        id: fileDialog
        anchors.fill: parent
        modal: true
        title: "Select a File"
        onAccepted: {
            console.log("File selected:", fileDialog.fileUrl)
        }
        onRejected: {
            console.log("File dialog canceled")
        }
    }

    Sidebar {
        id: sidebar
        width: 200
        anchors.verticalCenter: parent.verticalCenter
        onFolderSelected: {
            fileListView.updateFolder(sidebar.selectedFolder)
        }
    }

    FileListView {
        id: fileListView
        anchors.left: sidebar.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        onFileSelected: {
            fileDialog.fileUrl = fileListView.selectedFileUrl
            fileDialog.accept()
        }
    }
}