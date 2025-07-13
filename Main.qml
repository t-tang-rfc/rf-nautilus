import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    visible: true
    width: 800
    height: 600
    title: qsTr("Custom File Dialog Demo")

    CustomFileDialog {
        anchors.fill: parent
    }
}
