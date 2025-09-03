import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml
import Qt.labs.folderlistmodel

/*
  UsbFileDialog.qml
  - Minimal, focused file dialog restricted to /media
  - Simple, keyboard-friendly UI
  - Prevents navigating above rootUrl (default: file:///media)

  Public API
  -----------
  property url rootUrl            // read-only root; default file:///media
  property url currentUrl         // current folder within root
  property url selectedUrl        // selected file or folder
  property bool selectFolders     // if true, "Open" accepts folders
  property var nameFilters        // e.g. ["*.txt", "*.pdf"]
  signal accepted(url url)
  signal canceled()

  Notes
  -----
  * This QML-only version restricts UI navigation. For true enforcement,
    validate/guard the returned path in C++ before using it.
*/

Popup {
    id: root
    modal: true
    focus: true
    padding: 0
    width: 760
    height: 520
    dim: true

    property url rootUrl: "file:///media"
    property url currentUrl: root.rootUrl
    property url selectedUrl: ""
    property bool selectFolders: false
    property var nameFilters: ["*"]

    signal accepted(url url)
    signal canceled()

    onOpened: {
        currentUrl = rootUrl
        selectedUrl = ""
        fileView.forceActiveFocus()
    }

    // Helpers --------------------------------------------------------------
    function isUnderRoot(u) {
        const s = String(u)
        const r = String(rootUrl)
        return s.startsWith(r)
    }
    function ensureFolder(u) {
        // Remove trailing slash except root
        let s = String(u)
        if (s.length > 0 && s.endsWith("/") && s !== String(rootUrl)) s = s.slice(0, -1)
        return s
    }
    function parentUrl(u) {
        const r = String(rootUrl)
        let s = ensureFolder(u)
        const i = s.lastIndexOf('/')
        if (i <= r.length) return r
        return s.slice(0, i)
    }
    function humanSize(bytes) {
        if (bytes === undefined || bytes === null) return ""
        const b = Number(bytes)
        if (b < 1024) return b + " B"
        const units = ["KB","MB","GB","TB"]
        let val = b / 1024
        let idx = 0
        while (val >= 1024 && idx < units.length - 1) { val /= 1024; idx++ }
        return (Math.round(val * 10) / 10) + " " + units[idx]
    }
    function acceptSelection() {
        if (!selectedUrl) return
        if (!isUnderRoot(selectedUrl)) return
        // If selecting files only, ensure chosen item is a file
        const isDir = folderModel.isFolder(selectedUrl)
        if (!selectFolders && isDir) return
        root.accepted(selectedUrl)
        root.close()
    }
    function goUp() {
        const p = parentUrl(currentUrl)
        if (p !== currentUrl && isUnderRoot(p)) currentUrl = p
    }

    // Models ---------------------------------------------------------------
    // Sidebar: list mounted devices (subdirectories of /media)
    FolderListModel {
        id: mountsModel
        folder: root.rootUrl
        showDirs: true
        showFiles: false
        nameFilters: ["*"]
        sortField: FolderListModel.Name
        sortReversed: false
    }

    // Main file model for current folder
    FolderListModel {
        id: folderModel
        folder: root.currentUrl
        nameFilters: root.nameFilters
        showDirs: true
        showDotAndDotDot: false
        showFiles: true
        sortField: FolderListModel.Type | FolderListModel.Name
        sortReversed: false

        // Convenience helper used above
        function isFolder(urlStr) {
            // Iterate to find matching entry; cheap for short lists
            for (let i = 0; i < count; ++i) {
                if (get(i, "fileURL") === String(urlStr))
                    return get(i, "fileIsDir")
            }
            return false
        }
    }

    background: Rectangle { color: "#fff"; radius: 10; border.color: "#D9D9DF" }

    contentItem: RowLayout {
        spacing: 0

        // Sidebar ---------------------------------------------------------
        Frame {
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            padding: 0
            background: Rectangle { color: "#F6F7F9"; radius: 10; border.color: "#E5E7EB" }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Label {
                    text: "USB Devices"
                    padding: 10
                    font.bold: true
                }

                ListView {
                    id: mountsView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: mountsModel
                    delegate: ItemDelegate {
                        width: ListView.view.width
                        text: fileName
                        icon.source: fileIsDir ? "image://theme/folder" : ""
                        onClicked: {
                            const tgt = fileURL
                            if (isUnderRoot(tgt)) {
                                currentUrl = tgt
                                selectedUrl = ""
                            }
                        }
                    }
                }
            }
        }

        // Main pane -------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Top bar: breadcrumb + search/filter (optional)
            Rectangle {
                Layout.fillWidth: true
                height: 46
                color: "#FBFBFD"
                border.color: "#E5E7EB"

                RowLayout {
                    anchors.fill: parent
                    spacing: 6

                    ToolButton {
                        text: "⟵"
                        enabled: String(currentUrl) !== String(rootUrl)
                        onClicked: goUp()
                        ToolTip.visible: hovered
                        ToolTip.text: "Up"
                    }

                    Flickable {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height
                        interactive: true
                        contentWidth: crumbRow.implicitWidth
                        clip: true
                        Row {
                            id: crumbRow
                            spacing: 4
                            anchors.verticalCenter: parent.verticalCenter
                            Repeater {
                                id: crumbs
                                model: (function() {
                                    const r = String(rootUrl)
                                    const c = ensureFolder(String(currentUrl))
                                    let parts = []
                                    if (c.startsWith(r)) {
                                        const rel = c.slice(r.length)
                                        const segs = rel.split('/').filter(s => s.length)
                                        // Build cumulative paths
                                        let acc = r
                                        parts.push({ name: "/media", url: r })
                                        for (let i=0;i<segs.length;i++) {
                                            acc += (acc.endsWith('/')?"":"/") + segs[i]
                                            parts.push({ name: segs[i], url: acc })
                                        }
                                    }
                                    return parts
                                })()
                                delegate: Row {
                                    spacing: 4
                                    Button {
                                        text: modelData.name
                                        flat: true
                                        onClicked: currentUrl = modelData.url
                                    }
                                    Label { text: index < crumbs.count-1 ? "/" : "" }
                                }
                            }
                        }
                    }

                    // Name filter pill (optional simple view-only)
                    Label {
                        text: nameFilters && nameFilters.length ? nameFilters.join(", ") : "*"
                        padding: 8
                        background: Rectangle { color: "#EEF2FF"; radius: 6 }
                    }
                }
            }

            // Headers
            Rectangle {
                Layout.fillWidth: true
                height: 28
                color: "#F3F4F6"
                border.color: "#E5E7EB"
                RowLayout { anchors.fill: parent; spacing: 0
                    Label { text: "Name"; font.bold: true; padding: 6; Layout.fillWidth: true }
                    Label { text: "Size"; font.bold: true; padding: 6; Layout.preferredWidth: 100; horizontalAlignment: Text.AlignRight }
                }
            }

            // File list
            ListView {
                id: fileView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: folderModel
                clip: true
                currentIndex: -1
                keyNavigationWraps: false
                focus: true

                Keys.onPressed: (e) => {
                    if (e.key === Qt.Key_Enter || e.key === Qt.Key_Return) {
                        if (currentIndex >= 0) delegateActivate(currentIndex)
                        else acceptSelection()
                        e.accepted = true
                    } else if (e.key === Qt.Key_Escape) {
                        root.canceled(); root.close(); e.accepted = true
                    } else if (e.key === Qt.Key_Backspace) {
                        goUp(); e.accepted = true
                    }
                }

                function delegateActivate(i) {
                    if (i < 0 || i >= folderModel.count) return
                    const url = folderModel.get(i, "fileURL")
                    const isDir = folderModel.get(i, "fileIsDir")
                    if (isDir) {
                        if (isUnderRoot(url)) {
                            currentUrl = url
                            selectedUrl = ""
                            currentIndex = -1
                        }
                    } else {
                        selectedUrl = url
                        acceptSelection()
                    }
                }

                ScrollBar.vertical: ScrollBar {}

                delegate: ItemDelegate {
                    width: ListView.view.width
                    height: 32
                    highlighted: ListView.isCurrentItem
                    onClicked: {
                        ListView.view.currentIndex = index
                        const url = fileURL
                        if (fileIsDir) {
                            // Single-click to navigate; adjust to double-click if desired
                            if (isUnderRoot(url)) {
                                currentUrl = url
                                selectedUrl = ""
                                ListView.view.currentIndex = -1
                            }
                        } else {
                            selectedUrl = url
                        }
                    }
                    contentItem: RowLayout {
                        spacing: 8
                        Label { text: fileIsDir ? "📁" : "📄"; padding: 6 }
                        Label {
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            text: fileName
                            verticalAlignment: Text.AlignVCenter
                        }
                        Label {
                            Layout.preferredWidth: 100
                            horizontalAlignment: Text.AlignRight
                            text: fileIsDir ? "—" : humanSize(fileSize)
                            padding: 6
                        }
                    }
                }

                footer: Label {
                    text: "This folder is empty"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width
                    height: 60
                    color: "#9CA3AF"
                    visible: folderModel.count === 0
                }
            }

            // Filename + actions
            Rectangle {
                Layout.fillWidth: true
                height: 64
                color: "#FBFBFD"
                border.color: "#E5E7EB"
                RowLayout { anchors.fill: parent; anchors.margins: 10; spacing: 10
                    Label { text: selectFolders ? "Folder:" : "File:"; Layout.preferredWidth: 60 }
                    TextField {
                        Layout.fillWidth: true
                        readOnly: true
                        placeholderText: selectFolders ? "Select a folder" : "Select a file"
                        text: selectedUrl ? decodeURIComponent(String(selectedUrl).replace("file://", "")) : ""
                    }
                    Button { text: "Cancel"; onClicked: { root.canceled(); root.close() } }
                    Button {
                        id: openBtn
                        text: "Open"
                        enabled: selectedUrl && isUnderRoot(selectedUrl) && (selectFolders || !folderModel.isFolder(selectedUrl))
                        onClicked: acceptSelection()
                        highlighted: true
                    }
                }
            }
        }
    }
}
