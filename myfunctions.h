#ifndef MYFUNCTIONS_H
#define MYFUNCTIONS_H

#include <QObject>
#include <QString>
#include <QtDebug>
#include <QProcess>

class myFunctions : public QObject
{
    Q_OBJECT
public:
    myFunctions(QObject *parent = nullptr);
    // Here add all needed functions to play balitsa ... alefas
    //
    Q_INVOKABLE void lsHome(const QString & user_name);
};

#endif // MYFUNCTIONS_H
