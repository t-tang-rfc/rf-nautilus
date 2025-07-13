import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: folderItem
    width: 200
    height: 50
    color: "transparent"
    border.color: "lightgray"
    border.width: 1
    radius: 5
    anchors.horizontalCenter: parent.horizontalCenter

    Row {
        anchors.fill: parent
        spacing: 10

        Image {
            source: "folder-icon.png" // Placeholder for folder icon
            width: 32
            height: 32
        }

        Text {
            id: folderName
            text: model.folderName
            font.pointSize: 14
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Handle folder selection
                folderItem.selected = true;
                folderItem.clicked();
            }
        }
    }

    property bool selected: false

    signal clicked()
}