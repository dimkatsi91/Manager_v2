#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include "mymanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    // Set Qt Quick Application Stype to Imagine
    //
    QQuickStyle::setStyle("Imagine");

    // create a myManager class Object to use its def()'s
    myManager diman;

    engine.rootContext()->setContextProperty("myManager", &diman);

    // Introduce myFunctions package that will be imported in QML code to call c++ functions | <<<220>>>
    //
    //qmlRegisterType<myFunctions>("myFunctions", 1, 0, "myFunctions");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
