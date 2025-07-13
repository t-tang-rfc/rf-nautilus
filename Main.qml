import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#eeeeee"
    width: 600
    height: 400

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar for directory navigation
        ListView {
            id: directoryList
            width: 150
            Layout.fillHeight: true
            clip: true
            model: ListModel {
                id: directoryModel
                ListElement { name: "Home" }
                ListElement { name: "Documents" }
                ListElement { name: "Downloads" }
            }
            delegate: ItemDelegate {
                width: parent.width
                text: name
            }
        }

        // Main file area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            RowLayout {
                id: headerRow
                height: 30
                width: parent.width
                Rectangle {
                    color: "#cccccc"
                    Layout.fillWidth: true
                    height: parent.height
                    Label {
                        anchors.centerIn: parent
                        text: "File Name"
                    }
                }
                Rectangle {
                    color: "#cccccc"
                    width: 80
                    height: parent.height
                    Label {
                        anchors.centerIn: parent
                        text: "Size"
                    }
                }
            }

            ListView {
                id: fileList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: ListModel {
                    id: fileModel
                    ListElement { fileName: "file1.txt"; fileSize: "1 KB" }
                    ListElement { fileName: "file2.jpg"; fileSize: "2 MB" }
                    ListElement { fileName: "video.mp4"; fileSize: "10 MB" }
                }
                delegate: RowLayout {
                    width: fileList.width
                    spacing: 0
                    Label {
                        text: fileName
                        Layout.fillWidth: true
                        padding: 8
                    }
                    Label {
                        text: fileSize
                        width: 80
                        padding: 8
                    }
                }
            }
        }
    }
}
