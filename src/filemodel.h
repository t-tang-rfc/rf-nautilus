#ifndef FILEMODEL_H
#define FILEMODEL_H

#include <QAbstractListModel>
#include <QDir>
#include <QFileInfo>
#include <QStringList>

class FileModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum FileRoles {
        FilePathRole = Qt::UserRole + 1,
        FileNameRole,
        IsDirectoryRole
    };

    explicit FileModel(QObject *parent = nullptr);
    void setRootPath(const QString &path);
    QString rootPath() const;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    QStringList filterAccessibleFolders(const QStringList &folders) const;

    QString m_rootPath;
    QList<QFileInfo> m_fileInfoList;
};

#endif // FILEMODEL_H