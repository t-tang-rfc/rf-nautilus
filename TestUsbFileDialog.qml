import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    visible: true
    width: 400
    height: 300
    title: "USB File Dialog Test"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Label {
            text: "Click the button to open the USB File Dialog"
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            text: "Open USB File Dialog"
            Layout.alignment: Qt.AlignHCenter
            onClicked: usbDialog.open()
        }

        Label {
            id: resultLabel
            text: "No file selected yet"
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.maximumWidth: 350
        }
    }

    UsbFileDialog {
        id: usbDialog
        // Optional customizations:
        // selectFolders: true
        // nameFilters: ["*.txt", "*.pdf"]
        
        onAccepted: (url) => {
            console.log("User chose:", url)
            resultLabel.text = "Selected: " + url
            // ⚠️ Server-side/C++ guard recommended for security
        }
        
        onCanceled: {
            console.log("User canceled")
            resultLabel.text = "Dialog was canceled"
        }
    }
}
