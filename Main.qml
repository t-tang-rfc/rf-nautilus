import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "Custom File Dialog"

    FileDialog {
        anchors.fill: parent
    }
}
