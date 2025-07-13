# QML File Dialog

This project implements a custom Qt QML file dialog suitable for a kiosk-style application on Ubuntu. The file dialog features a sidebar for folder navigation and a main list-display window for viewing files and folders.

## Project Structure

- **qml/**
  - **main.qml**: Entry point for the QML application, initializing the file dialog interface.
  - **FileDialog.qml**: Custom file dialog component with sidebar and main display.
  - **Sidebar.qml**: Sidebar component for folder navigation.
  - **FileListView.qml**: Displays contents of the selected folder.
  - **components/**
    - **FolderItem.qml**: Visual representation of a folder item.
    - **FileItem.qml**: Visual representation of a file item.

- **src/**
  - **main.cpp**: Entry point of the C++ application, initializes the QML engine.
  - **filemodel.h**: Declaration of the FileModel class for managing file system data.
  - **filemodel.cpp**: Implementation of the FileModel class, handling folder access constraints.
  - **qml.qrc**: Resource file for including QML files in the project.

- **CMakeLists.txt**: Configuration file for CMake, specifying project settings and build instructions.

## Setup Instructions

1. Clone the repository or download the project files.
2. Ensure you have Qt and CMake installed on your Ubuntu system.
3. Navigate to the project directory in the terminal.
4. Create a build directory:
   ```
   mkdir build
   cd build
   ```
5. Run CMake to configure the project:
   ```
   cmake ..
   ```
6. Build the project:
   ```
   make
   ```
7. Run the application:
   ```
   ./your_application_name
   ```

## Usage Guidelines

- The sidebar allows users to navigate through folders. Click on a folder to view its contents in the main display area.
- The main list-display window shows files and subfolders of the currently selected folder.
- Folder access constraints are implemented to restrict navigation to specific directories, ensuring a secure kiosk environment.

## Additional Information

This project is designed for simplicity and ease of use, making it ideal for kiosk applications where user interaction needs to be limited and controlled.