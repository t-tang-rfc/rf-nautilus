project(qml-file-dialog)

cmake_minimum_required(VERSION 3.5)

set(CMAKE_CXX_STANDARD 11)

find_package(Qt5 COMPONENTS Core Quick REQUIRED)

set(QML_FILES
    qml/main.qml
    qml/FileDialog.qml
    qml/Sidebar.qml
    qml/FileListView.qml
    qml/components/FolderItem.qml
    qml/components/FileItem.qml
)

set(SOURCES
    src/main.cpp
    src/filemodel.cpp
)

set(HEADERS
    src/filemodel.h
)

qt5_add_resources(QML_RESOURCES qml.qrc)

add_executable(qml-file-dialog ${SOURCES} ${HEADERS} ${QML_RESOURCES})

target_link_libraries(qml-file-dialog Qt5::Core Qt5::Quick)

install(TARGETS qml-file-dialog DESTINATION bin)