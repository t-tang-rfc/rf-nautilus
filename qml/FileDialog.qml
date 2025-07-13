import QtQuick 2.15
import QtQuick.Controls 2.15

FileDialog {
    id: fileDialog
    width: 800
    height: 600
    title: "Custom File Dialog"

    // Sidebar for folder navigation
    Sidebar {
        id: sidebar
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 200
        onFolderSelected: {
            fileListView.loadFolder(folderPath);
        }
    }

    // Main list display for files and folders
    FileListView {
        id: fileListView
        anchors.left: sidebar.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }

    // Function to handle folder access constraints
    function setFolderAccessConstraints(allowedPaths) {
        sidebar.allowedPaths = allowedPaths;
        fileListView.allowedPaths = allowedPaths;
    }
}