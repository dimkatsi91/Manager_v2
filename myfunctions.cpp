#include "myfunctions.h"

#include <QString>
#include <QtDebug>
#include <QProcess>

// Here add all needed functions to play balitsa ... alefas
//
void myFunctions::lsHome(const QString & user_name)
{
    qDebug() << "Called the C++ method with for ls /home/" << user_name << endl;
}
