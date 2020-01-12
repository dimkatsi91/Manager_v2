#ifndef MYMANAGER_H
#define MYMANAGER_H

#include <QObject>
#include <QString>
#include <QProcess>
#include <QList>
#include <QVector>
#include <QDebug>
#include <QRegularExpression>

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
    // Overload this function too || needed
    Q_INVOKABLE bool is_username_valid(QString userName);
    Q_INVOKABLE bool adduser();
    Q_INVOKABLE bool deluser();
    Q_INVOKABLE bool user_exists();
    /* set ownership and permissions for the new user's home directory
     * in order to be able to lg in there when login to the system
     */
    Q_INVOKABLE bool set_chown();
    Q_INVOKABLE bool set_chmod();
    Q_INVOKABLE bool del_user_home();

    /*
     * System & Networking Section related functions
     */
    // List / grep real human system users
    Q_INVOKABLE QString cat_users();
    // List / grep all real system groups
    Q_INVOKABLE QString cat_groups();
    Q_INVOKABLE QString cat_shells();
    Q_INVOKABLE QString ifconfig();
    Q_INVOKABLE QString netstat();
    // Return Firewall configuration for specific Table
    //
    Q_INVOKABLE QString ip4tables();
    Q_INVOKABLE QString ip6tables();

    Q_INVOKABLE void setTable(const QString table);
    Q_INVOKABLE QString getTable() const;

    /*
     * Group Management related functions
    */
    Q_INVOKABLE QString getGroupname() const;
    Q_INVOKABLE void setGroupname(const QString &value);
    Q_INVOKABLE QString getNew_groupname() const;
    Q_INVOKABLE void setNew_groupname(const QString &value);
    Q_INVOKABLE QString getGid() const;
    Q_INVOKABLE void setGid(const QString &value);
    // Create a new group
    Q_INVOKABLE bool groupadd();
    // Rename an existing group
    Q_INVOKABLE bool groupmod();
    // Remove an existing group
    Q_INVOKABLE bool groupdel();
    // Check if a group exists
    Q_INVOKABLE bool group_exists();

    // A Q_PROPERTY for set/get/signal for password complexity in real time when
    // the user enters the password for the new user that is about to be created
    //
    Q_PROPERTY(QString passComplexity READ passComplexity WRITE setPassComplexity NOTIFY passComplexityChanged)

    Q_INVOKABLE QString passComplexity() const;
    Q_INVOKABLE void setPassComplexity(QString passComplexity);

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
    // Firewall Table
    //
    QString firewallTable;

    // New user's password complexity
    // Weak || Medium || Strong
    QString m_passComplexity;

signals:
    // no need for now | everything is controled by the QML UI code
    // 12/1/2020 :: Update --> now it is needed !!!
    void passComplexityChanged(QString passComplexity);
};

#endif // MYMANAGER_H
