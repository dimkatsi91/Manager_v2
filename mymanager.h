#ifndef MYMANAGER_H
#define MYMANAGER_H

#include <QObject>
#include <QString>
#include <QDebug>
#include <QProcess>
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

    // compare/check if entered username is the same as current logged into system username
    //
    Q_INVOKABLE bool compare_usernames();

    // A clearCredetials function that is executed when the Clear switch is swiped to the right
    //
    Q_INVOKABLE void clearCredentials();

    /*
     * User Management related functions
     */
    void create_enc_password();
    bool is_username_valid();
    bool adduser();
    bool deluser();
    bool user_exists();
    /* set ownership and permissions for the new user's home directory
     * in order to be able to lg in there when login to the system
     */
    bool set_chown();
    bool set_chmod();
    bool del_user_home();

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
