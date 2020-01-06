#include "mymanager.h"


myManager::myManager(QObject *parent) : QObject(parent)
{

}


/* ============================================================================================================ */
/*                                      SECTION I : Credentials                                                 */
/* ============================================================================================================ */
QString myManager::getPassword() const
{
    return password;
}

void myManager::setPassword(const QString &value)
{
    password = value;
}

QString myManager::getUsername() const
{
    return username;
}

void myManager::setUsername(const QString &value)
{
    username = value;
}

QString myManager::getNew_user_shell() const
{
    return new_user_shell;
}

void myManager::setNew_user_shell(const QString &value)
{
    new_user_shell = value;
}

QString myManager::getNew_user_id() const
{
    return new_user_id;
}

void myManager::setNew_user_id(const QString &value)
{
    new_user_id = value;
}

QString myManager::getNew_user_group() const
{
    return new_user_group;
}

void myManager::setNew_user_group(const QString &value)
{
    new_user_group = value;
}

QString myManager::getNew_user_realname() const
{
    return new_user_realname;
}

void myManager::setNew_user_realname(const QString &value)
{
    new_user_realname = value;
}

QString myManager::getNew_username() const
{
    return new_username;
}

void myManager::setNew_username(const QString &value)
{
    new_username = value;
}

QString myManager::getNew_user_encr_password() const
{
    return new_user_encr_password;
}

void myManager::setNew_user_encr_password(const QString &value)
{
    new_user_encr_password = value;
}

// Compare the entered username with the username that is returned by the Qt
bool myManager::compare_usernames()
{
    QString current_user = getenv("USER");
    // qDebug() << "Current user: " << current_user << " Entered user: " << getUsername() << endl;
    if(getUsername()!=current_user)
    {
        return false;
    }
    return true;
}

void myManager::clearCredentials()
{
    // clean username and password fields up
    setUsername("");
    setPassword("");
    qDebug() << "Cleaned up username and password fields from c++ code ..." << endl;
}

// CHeck if a user exists in the system
bool myManager::user_exists()
{
    QProcess proc;
    proc.start("id " + getNew_username());
    proc.waitForFinished(-1);
    if(proc.exitCode()!=0)
    {
        return false;
    }
    return true;
}

// Add a new user in the system
//useradd command example :: useradd -c "Real User Name" -m -u <UID> -g <GROUP> -d /home/$username -s <shell> $username
bool myManager::is_username_valid()
{
    // Name of the new user should not start with a digit
    // Also a username in Linux should be lower case name
    if(getNew_username() == getenv("USER") || getNew_username().at(0).isDigit() || getNew_username().at(0).isUpper())
    {
        return false;
    }
    QVector<QString> invalid_characters = {"`", "~", "@", "!", "#", "$", "%", "^", "&", "*", "(", ")", "-", "+", "<", ">", ",", ".", "=", "_", "/", ";", ":", "?"};
    QVector<QString>::iterator start = invalid_characters.begin();
    if(getNew_username()=="root")
    {
        return false;
    }
    while(start != invalid_characters.end())
    {
        if(getNew_username().at(0) == *start)
        {
            return false;
        }
        start++;
    }

    return true;
}

void myManager::create_enc_password()
{
    // opnssl passwd <plain_password>  --> creates the encrypted password hash
    // to be used with the useradd -p <password_hash> option !
    QProcess openssl;
    openssl.start("openssl passwd " + getNew_user_encr_password());
    openssl.waitForFinished();
    QString hold(openssl.readAllStandardOutput());
    hold.remove("\n");
    setNew_user_encr_password(hold);
    if(openssl.exitCode()!=0)
    {
        new_user_encr_password = "";
    }
}

// Ownership & Permissions for the home directory of the new user
bool myManager::set_chown()
{
    QProcess passwd, chown;
    passwd.setStandardOutputProcess(&chown);
    passwd.start("echo " + getPassword());
    chown.start("sudo -S chown " + getNew_username() + " /home/" + getNew_username());
    chown.waitForFinished(-1);
    passwd.waitForFinished(-1);
    if(chown.exitCode()!=0)
    {
        return false;
    }
    return true;
}

bool myManager::set_chmod()
{
    QProcess pass, chmod;
    pass.setStandardOutputProcess(&chmod);
    pass.start("echo " + getPassword());
    chmod.start("sudo -S chmod -R u=rwx,g=rw,o=--- /home/" + getNew_username());
    chmod.waitForFinished(-1);
    pass.waitForFinished(-1);
    if(chmod.exitCode()!=0)
    {
        return false;
    }
    return true;
}

// Create the new user using a QProcess
bool myManager::adduser()
{
    qDebug() << "Just entered adduser() c++ function ...\n";
    qDebug() << "Current user is: " << getUsername() << endl;
    qDebug() << "Password is: " << getPassword() << endl;
    qDebug() << "New username: " << getNew_username() << endl;
    qDebug() << "New user real name: " << getNew_user_realname() << endl;
    qDebug() << "New user group : " << getNew_user_group() << endl;
    qDebug() << " New user ID: " << getNew_user_id() << endl;
    qDebug() << " Shell: " << getNew_user_shell() << endl;

    QString options;
    QProcess pass, add;
    pass.setStandardOutputProcess(&add);
    pass.start("echo " + getPassword());
    if(!getNew_user_realname().isEmpty())
    {
        options += " -c \"" + getNew_user_realname() + "\"";
    }
    if(!getNew_user_group().isEmpty())
    {
        options += " -g " + getNew_user_group();
    }
    if(!getNew_user_id().isEmpty())
    {
        options += " -u " + getNew_user_id();
    }
    options += " -m -d /home/" + getNew_username();
    if(!getNew_user_shell().isEmpty())
    {
        options += " -s /bin/" + getNew_user_shell();
    }
    // Call create_enc_password() to create the Hash of the entered password
    //
    create_enc_password();
    options += " -p " + new_user_encr_password;
    options += " " + getNew_username();
    qDebug() << "useradd() command: useradd " << options << endl;
    add.start("sudo -S useradd " + options);
    add.waitForFinished(-1);
    pass.waitForFinished(-1);
    if(add.exitCode()!=0)
    {
        return false;
    }
    set_chmod();
    set_chown();
    return true;
}

// REMOVE A USER
bool myManager::deluser()
{
    QProcess pass, del;
    pass.setStandardOutputProcess(&del);
    pass.start("echo " + getPassword());
    del.start("sudo -S userdel " + getNew_username());
    pass.waitForFinished(-1);
    del.waitForFinished(-1);
    if(del.exitCode()!=0)
    {
        return false;
    }
    return true;
}


// Delete the user's home directory
bool myManager::del_user_home()
{
    QProcess pass, rm_dir;
    pass.setStandardOutputProcess(&rm_dir);
    pass.start("echo " + getPassword());
    rm_dir.start("sudo -S rm -r /home/" + getNew_username());
    pass.waitForFinished(-1);
    rm_dir.waitForFinished(-1);
    if(rm_dir.exitCode()!=0)
    {
        return false;
    }
    return true;
}
/* ============================================================================================================ */
/*                              SECTION II : System & Networking Section                                        */
/* ============================================================================================================ */
QString myManager::cat_users()
{
    QProcess users_proc;
    QString real_users;
    users_proc.start("bash", QStringList() << "-c" << "cut -d: -f1,3 /etc/passwd | egrep ':[0-9]{4}$' | cut -d: -f1");
    if(!users_proc.waitForFinished(3000) || users_proc.exitCode()!=0)
    {
        // upon error return error
        return "ERROR";
    }
    real_users = users_proc.readAllStandardOutput();
    return real_users;
}


QString myManager::cat_groups()
{
    QProcess groups_proc;
    QString real_groups;
    groups_proc.start("bash", QStringList() << "-c" << "cut -d: -f1,3 /etc/group | egrep ':[0-9]{4}$' | cut -d: -f1");
    if(!groups_proc.waitForFinished(3000) || groups_proc.exitCode()!=0)
    {
        return "ERROR";
    }
    real_groups = groups_proc.readAllStandardOutput();
    return real_groups;
}

QString myManager::cat_shells()
{
    QProcess shells_proc;
    QString shells;
    shells_proc.start("cat /etc/shells");
    if(!shells_proc.waitForFinished(-1) || shells_proc.exitCode()!=0)
    {
        return "ERROR";
    }
    shells = shells_proc.readAllStandardOutput();
    return shells;
}

QString myManager::ifconfig()
{
    QProcess ifconf;
    ifconf.start("ifconfig");
    ifconf.waitForFinished(-1);
    QString hold(ifconf.readAllStandardOutput());
    if(ifconf.exitCode()!=0)
    {
        return "ERROR";
    }
    return hold;
}

QString myManager::netstat()
{
    QProcess net;
    // r -> display routing table argument
    net.start("netstat -r");
    net.waitForFinished(-1);
    QString hold(net.readAllStandardOutput());
    if(net.exitCode()!=0)
    {
        return "ERROR";
    }
    return hold;
}

void myManager::setTable(const QString table)
{
    firewallTable = table;
}

QString myManager::getTable() const
{
    return firewallTable;
}

QString myManager::ip4tables()
{
    QProcess pass, ip_proc;
    pass.setStandardOutputProcess(&ip_proc);
    pass.start("echo " + getPassword());
    ip_proc.start("sudo -S iptables -t " + getTable() + " -nL --line-numbers");
    ip_proc.waitForFinished(6000);
    pass.waitForFinished(6000);
    QString hold(ip_proc.readAllStandardOutput());
    qDebug() << "iptables command: " << hold << endl;
    if(ip_proc.exitCode()!=0)
    {
        return "ERROR";
    }
    return hold;
}

QString myManager::ip6tables()
{
    QProcess pass, ip_proc;
    pass.setStandardOutputProcess(&ip_proc);
    pass.start("echo " + getPassword());
    ip_proc.start("sudo -S ip6tables -t " + getTable() + " -nL --line-numbers");
    ip_proc.waitForFinished(6000);
    pass.waitForFinished(6000);
    QString hold(ip_proc.readAllStandardOutput());
    if(ip_proc.exitCode()!=0)
    {
        return "ERROR";
    }
    return hold;
}

/* ============================================================================================================ */
/*                                      SECTION III : Group Management                                          */
/* ============================================================================================================ */
QString myManager::getGid() const
{
    return gid;
}

void myManager::setGid(const QString &value)
{
    gid = value;
}

QString myManager::getNew_groupname() const
{
    return new_groupname;
}

void myManager::setNew_groupname(const QString &value)
{
    new_groupname = value;
}

QString myManager::getGroupname() const
{
    return groupname;
}

void myManager::setGroupname(const QString &value)
{
    groupname = value;
}

bool myManager::group_exists()
{
    QProcess proc;
    proc.start("getent group " + getGroupname());
    proc.waitForFinished(-1);
    if(proc.exitCode()!=0)
    {
        return false;
    }
    return true;
}

bool myManager::groupadd()
{
    QProcess pass, add;
    pass.setStandardOutputProcess(&add);
    pass.start("echo " + getPassword());
    if(gid.isEmpty())
    {
        add.start("sudo -S groupadd " + getGroupname());
    }
    else {
        add.start("sudo -S groupadd -g " + getGid() + " " + getGroupname());
    }
    pass.waitForFinished(-1);
    add.waitForFinished(-1);
    if(add.exitCode()!=0)
    {
        return false;
    }
    return true;
}

bool myManager::groupmod()
{
    QProcess pass, mod;
    pass.setStandardOutputProcess(&mod);
    pass.start("echo " + getPassword());
    mod.start("sudo -S groupmod -n " + getNew_groupname() + " " + getGroupname());
    qDebug() << "groupmod command debug: " << "sudo -S groupmod -n " << getNew_groupname() << " " << getGroupname() << endl;
    pass.waitForFinished(-1);
    mod.waitForFinished(-1);
    if(mod.exitCode()!=0)
    {
        return false;
    }
    return true;
}

bool myManager::groupdel()
{
    QProcess pass, del;
    pass.setStandardOutputProcess(&del);
    pass.start("echo " + getPassword());
    del.start("sudo -S groupdel " + getGroupname());
    pass.waitForFinished(-1);
    del.waitForFinished(-1);
    if(del.exitCode()!=0)
    {
        return false;
    }
    return true;
}

