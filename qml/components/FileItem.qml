import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: fileItem
    width: 200
    height: 50

    property string fileName: ""
    property string filePath: ""
    property bool isFolder: false

    Rectangle {
        anchors.fill: parent
        color: isFolder ? "#e0e0e0" : "#ffffff"
        border.color: "#cccccc"
        border.width: 1
        radius: 4

        Text {
            anchors.centerIn: parent
            text: fileName
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (isFolder) {
                    // Logic to handle folder selection
                    fileItem.fileSelected(filePath);
                } else {
                    // Logic to handle file selection
                    fileItem.fileSelected(filePath);
                }
            }
        }
    }

    signal fileSelected(string filePath)
}