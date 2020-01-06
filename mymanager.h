#ifndef MYMANAGER_H
#define MYMANAGER_H

#include <QObject>
#include <QString>
#include <QDebug>
#include <QProcess>
#include <QList>
#include <QVector>
#include <QtWidgets/QMessageBox>

class myManager : public QObject
{
    Q_OBJECT
public:
    explicit myManager(QObject *parent = nullptr);

    /* invokable functions to be called from QML UI code */
    /* c++ main functionality comes from following functions */
    /*
     * Credentials related functions
     */
    Q_INVOKABLE QString getUsername() const;
    Q_INVOKABLE void setUsername(const QString &value);

    Q_INVOKABLE QString getPassword() const;
    Q_INVOKABLE void setPassword(const QString &value);

    Q_INVOKABLE QString getNew_username() const;
    Q_INVOKABLE void setNew_username(const QString &value);

    Q_INVOKABLE QString getNew_user_realname() const;
    Q_INVOKABLE void setNew_user_realname(const QString &value);

    Q_INVOKABLE QString getNew_user_group() const;
    Q_INVOKABLE void setNew_user_group(const QString &value);

    Q_INVOKABLE QString getNew_user_id() const;
    Q_INVOKABLE void setNew_user_id(const QString &value);

    Q_INVOKABLE QString getNew_user_shell() const;
    Q_INVOKABLE void setNew_user_shell(const QString &value);

    Q_INVOKABLE QString getNew_user_encr_password() const;
    Q_INVOKABLE void setNew_user_encr_password(const QString &value);

    // compare/check if entered username is the same as current logged into system username
    //
    Q_INVOKABLE bool compare_usernames();

    // A clearCredetials function that is executed when the Clear switch is swiped to the right
    //
    Q_INVOKABLE void clearCredentials();

    /*
     * User Management related functions
     */
    Q_INVOKABLE void create_enc_password();
    Q_INVOKABLE bool is_username_valid();
    Q_INVOKABLE bool adduser();
    Q_INVOKABLE bool deluser();
    Q_INVOKABLE bool user_exists();
    /* set ownership and permissions for the new user's home directory
     * in order to be able to lg in there when login to the system
     */
    Q_INVOKABLE bool set_chown();
    Q_INVOKABLE bool set_chmod();
    Q_INVOKABLE bool del_user_home();

private:
    // username & password string variables
    //
    QString username;
    QString password;
    // Group Management related string variables
    QString groupname;
    QString new_groupname;
    QString gid;    // The GID (aka Group ID)
    // User Management related string variables
    QString new_username;
    QString new_user_realname;
    QString new_user_group;
    QString new_user_id;
    QString new_user_shell;
    QString new_user_encr_password;

signals:
    // no need for now | everything is controled by the QML UI code

};

#endif // MYMANAGER_H
