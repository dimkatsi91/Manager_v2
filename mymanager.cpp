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
    proc.waitForFinished();
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
    openssl.start("openssl passwd " + getNew_username());
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
    chown.waitForFinished(6000);
    passwd.waitForFinished(6000);
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
    chmod.waitForFinished(6000);
    pass.waitForFinished(6000);
    if(chmod.exitCode()!=0)
    {
        return false;
    }
    return true;
}

// Create tthe new user using a QProcess
bool myManager::adduser()
{
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
    options += " -p " + getNew_user_encr_password();
    options += " " + getNew_username();
    add.start("sudo -S useradd " + options);
    add.waitForFinished(-1);
    pass.waitForFinished(6000);
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
    pass.waitForFinished(6000);
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
    pass.waitForFinished(6000);
    rm_dir.waitForFinished(6000);
    if(rm_dir.exitCode()!=0)
    {
        return false;
    }
    return true;
}
