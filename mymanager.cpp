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

