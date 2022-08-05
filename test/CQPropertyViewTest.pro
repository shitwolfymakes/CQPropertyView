TEMPLATE = app

TARGET = CQPropertyViewTest

QT += widgets svg

DEPENDPATH += .

QMAKE_CXXFLAGS += -std=c++14

MOC_DIR = .moc

SOURCES += \
CQPropertyViewTest.cpp \

HEADERS += \
CQPropertyViewTest.h \

DESTDIR     = ../bin
OBJECTS_DIR = ../obj

INCLUDEPATH += \
. \
../include \
../external/CQUtil/include \
../external/CImageLib/include \
../external/CFont/include \
../external/CFile/include \
../external/CMath/include \
../external/CStrUtil/include \
../external/CUtil/include \
../external/COS/include \

unix:LIBS += \
-L../lib \
-L../external/CQUtil/lib \
-L../external/CImageLib/lib \
-L../external/CFont/lib \
-L../external/CConfig/lib \
-L../external/CUtil/lib \
-L../external/CFileUtil/lib \
-L../external/CFile/lib \
-L../external/CMath/lib \
-L../external/CStrUtil/lib \
-L../external/CRegExp/lib \
-L../external/COS/lib \
-lCQPropertyView -lCQUtil -lCImageLib -lCFont \
-lCConfig -lCUtil -lCFileUtil -lCFile -lCMath -lCRegExp -lCStrUtil \
-lCOS -lpng -ljpeg -ltre \
