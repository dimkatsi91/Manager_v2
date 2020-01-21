QT += quick quickcontrols2

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        mymanager.cpp

RESOURCES += qml.qrc \
    images/resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
CONFIG(release, debug|release): {

    QT_DIR= $$[QT_HOST_BINS]
    win32:QMAKE_BIN= \'$$QT_DIR/qmake.exe\'
    win32:DEPLOYER = %cqtdeployer%

    contains(QMAKE_HOST.os, Linux):{
        QMAKE_BIN= \'$$QT_DIR/qmake\'
        DEPLOYER = cqtdeployer
    }

    DEPLOY_TARGET = $${OUT_PWD}/$${DEBUG_OR_RELEASE}/$$TARGET
    BASE_DEPLOY_FLAGS = clear -qmake $$QMAKE_BIN -qmlDir \'$$PWD\'  -libDir '\$$PWD'\ -recursiveDepth 4
    deploy.commands = $$DEPLOYER -bin $$DEPLOY_TARGET $$BASE_DEPLOY_FLAGS

}

QMAKE_EXTRA_TARGETS += \
    deploy

HEADERS += \
    mymanager.h
