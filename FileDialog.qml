import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: "#ffffff"

    // Sidebar model
    ListModel {
        id: sidebarModel
        ListElement { name: "Home" }
        ListElement { name: "Documents" }
        ListElement { name: "Downloads" }
        ListElement { name: "Pictures" }
    }

    // File list model (dummy data)
    ListModel {
        id: fileModel
        ListElement { name: "File1.txt"; size: "12 KB" }
        ListElement { name: "File2.png"; size: "256 KB" }
        ListElement { name: "File3.pdf"; size: "1.1 MB" }
        ListElement { name: "Archive.zip"; size: "3.4 MB" }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar
        Rectangle {
            id: sidebar
            color: "#f0f0f0"
            Layout.preferredWidth: 160
            Layout.fillHeight: true

            ListView {
                anchors.fill: parent
                model: sidebarModel
                delegate: ItemDelegate {
                    width: parent.width
                    text: name
                }
            }
        }

        // Main area
        Rectangle {
            color: "#ffffff"
            border.color: "#c0c0c0"
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Header row
                Rectangle {
                    color: "#dcdcdc"
                    height: 30
                    Layout.fillWidth: true

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Text {
                            text: "Name"
                            font.bold: true
                            Layout.preferredWidth: 1
                            Layout.fillWidth: true
                            leftPadding: 8
                        }
                        Text {
                            text: "Size"
                            font.bold: true
                            horizontalAlignment: Text.AlignRight
                            Layout.preferredWidth: 80
                            rightPadding: 8
                        }
                    }
                }

                // File list
                ListView {
                    id: fileList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: fileModel
                    clip: true

                    delegate: Rectangle {
                        height: 28
                        width: parent.width
                        color: index % 2 === 0 ? "#ffffff" : "#f9f9f9"

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            Text {
                                text: name
                                Layout.preferredWidth: 1
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                leftPadding: 8
                            }
                            Text {
                                text: size
                                horizontalAlignment: Text.AlignRight
                                Layout.preferredWidth: 80
                                rightPadding: 8
                            }
                        }
                    }
                }
            }
        }
    }
}
