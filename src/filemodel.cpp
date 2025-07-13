#include "filemodel.h"
#include <QDir>
#include <QFileInfo>
#include <QDebug>

FileModel::FileModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int FileModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_files.size();
}

QVariant FileModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_files.size())
        return QVariant();

    const QFileInfo &fileInfo = m_files.at(index.row());
    if (role == NameRole)
        return fileInfo.fileName();
    else if (role == PathRole)
        return fileInfo.absoluteFilePath();
    else if (role == IsDirRole)
        return fileInfo.isDir();
    
    return QVariant();
}

QHash<int, QByteArray> FileModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[PathRole] = "path";
    roles[IsDirRole] = "isDir";
    return roles;
}

void FileModel::setRootPath(const QString &path)
{
    if (m_rootPath != path) {
        m_rootPath = path;
        loadFiles();
        emit rootPathChanged();
    }
}

QString FileModel::rootPath() const
{
    return m_rootPath;
}

void FileModel::loadFiles()
{
    beginResetModel();
    m_files.clear();

    QDir dir(m_rootPath);
    if (dir.exists()) {
        foreach (const QFileInfo &info, dir.entryInfoList(QDir::NoDotAndDotDot | QDir::AllEntries)) {
            if (isAccessible(info)) {
                m_files.append(info);
            }
        }
    }
    endResetModel();
}

bool FileModel::isAccessible(const QFileInfo &info) const
{
    // Implement folder access constraints here
    // For example, restrict access to certain folders
    return true; // Placeholder for actual access logic
}