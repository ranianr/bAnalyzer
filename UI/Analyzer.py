# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'UI/Analyzer.ui'
#
# Created: Wed Apr 23 16:29:07 2014
#      by: PyQt4 UI code generator 4.9.1
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    _fromUtf8 = lambda s: s

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName(_fromUtf8("MainWindow"))
        MainWindow.resize(639, 624)
        MainWindow.setToolButtonStyle(QtCore.Qt.ToolButtonIconOnly)
        MainWindow.setAnimated(False)
        MainWindow.setUnifiedTitleAndToolBarOnMac(True)
        self.centralWidget = QtGui.QWidget(MainWindow)
        self.centralWidget.setObjectName(_fromUtf8("centralWidget"))
        self.label = QtGui.QLabel(self.centralWidget)
        self.label.setGeometry(QtCore.QRect(10, 10, 161, 21))
        self.label.setObjectName(_fromUtf8("label"))
        self.label_2 = QtGui.QLabel(self.centralWidget)
        self.label_2.setGeometry(QtCore.QRect(360, 10, 161, 21))
        self.label_2.setObjectName(_fromUtf8("label_2"))
        self.label_3 = QtGui.QLabel(self.centralWidget)
        self.label_3.setGeometry(QtCore.QRect(10, 60, 111, 17))
        self.label_3.setObjectName(_fromUtf8("label_3"))
        self.label_5 = QtGui.QLabel(self.centralWidget)
        self.label_5.setGeometry(QtCore.QRect(10, 110, 211, 15))
        self.label_5.setObjectName(_fromUtf8("label_5"))
        self.label_6 = QtGui.QLabel(self.centralWidget)
        self.label_6.setGeometry(QtCore.QRect(10, 200, 221, 17))
        self.label_6.setObjectName(_fromUtf8("label_6"))
        self.label_7 = QtGui.QLabel(self.centralWidget)
        self.label_7.setGeometry(QtCore.QRect(10, 230, 211, 20))
        self.label_7.setObjectName(_fromUtf8("label_7"))
        self.BrowseButton = QtGui.QPushButton(self.centralWidget)
        self.BrowseButton.setGeometry(QtCore.QRect(228, 27, 99, 27))
        self.BrowseButton.setObjectName(_fromUtf8("BrowseButton"))
        self.FeatureEnhancementMethod = QtGui.QComboBox(self.centralWidget)
        self.FeatureEnhancementMethod.setGeometry(QtCore.QRect(220, 200, 151, 27))
        self.FeatureEnhancementMethod.setObjectName(_fromUtf8("FeatureEnhancementMethod"))
        self.ClassifierBox = QtGui.QComboBox(self.centralWidget)
        self.ClassifierBox.setGeometry(QtCore.QRect(220, 230, 151, 27))
        self.ClassifierBox.setObjectName(_fromUtf8("ClassifierBox"))
        self.removeNoiseChecked = QtGui.QRadioButton(self.centralWidget)
        self.removeNoiseChecked.setGeometry(QtCore.QRect(120, 110, 61, 20))
        self.removeNoiseChecked.setObjectName(_fromUtf8("removeNoiseChecked"))
        self.removeNoiseUnchecked = QtGui.QRadioButton(self.centralWidget)
        self.removeNoiseUnchecked.setGeometry(QtCore.QRect(190, 110, 117, 20))
        self.removeNoiseUnchecked.setObjectName(_fromUtf8("removeNoiseUnchecked"))
        self.datafile = QtGui.QTextEdit(self.centralWidget)
        self.datafile.setGeometry(QtCore.QRect(20, 30, 201, 21))
        self.datafile.setVerticalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.datafile.setHorizontalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.datafile.setObjectName(_fromUtf8("datafile"))
        self.TrainButton = QtGui.QPushButton(self.centralWidget)
        self.TrainButton.setGeometry(QtCore.QRect(270, 290, 99, 27))
        self.TrainButton.setObjectName(_fromUtf8("TrainButton"))
        self.subjectName = QtGui.QLabel(self.centralWidget)
        self.subjectName.setGeometry(QtCore.QRect(390, 30, 171, 17))
        self.subjectName.setText(_fromUtf8(""))
        self.subjectName.setObjectName(_fromUtf8("subjectName"))
        self.label_8 = QtGui.QLabel(self.centralWidget)
        self.label_8.setGeometry(QtCore.QRect(30, 80, 121, 17))
        self.label_8.setObjectName(_fromUtf8("label_8"))
        self.label_9 = QtGui.QLabel(self.centralWidget)
        self.label_9.setGeometry(QtCore.QRect(220, 80, 111, 17))
        self.label_9.setObjectName(_fromUtf8("label_9"))
        self.SampleStart = QtGui.QTextEdit(self.centralWidget)
        self.SampleStart.setGeometry(QtCore.QRect(140, 80, 51, 21))
        self.SampleStart.setVerticalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.SampleStart.setHorizontalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.SampleStart.setObjectName(_fromUtf8("SampleStart"))
        self.SampleEnd = QtGui.QTextEdit(self.centralWidget)
        self.SampleEnd.setGeometry(QtCore.QRect(320, 80, 51, 21))
        self.SampleEnd.setVerticalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.SampleEnd.setHorizontalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.SampleEnd.setObjectName(_fromUtf8("SampleEnd"))
        self.label_10 = QtGui.QLabel(self.centralWidget)
        self.label_10.setGeometry(QtCore.QRect(10, 150, 181, 17))
        self.label_10.setObjectName(_fromUtf8("label_10"))
        self.featureSelectionMethodBox = QtGui.QComboBox(self.centralWidget)
        self.featureSelectionMethodBox.setGeometry(QtCore.QRect(220, 140, 151, 27))
        self.featureSelectionMethodBox.setObjectName(_fromUtf8("featureSelectionMethodBox"))
        self.preprocessingBox = QtGui.QComboBox(self.centralWidget)
        self.preprocessingBox.setGeometry(QtCore.QRect(220, 170, 151, 27))
        self.preprocessingBox.setObjectName(_fromUtf8("preprocessingBox"))
        self.label_4 = QtGui.QLabel(self.centralWidget)
        self.label_4.setGeometry(QtCore.QRect(10, 174, 171, 17))
        self.label_4.setObjectName(_fromUtf8("label_4"))
        MainWindow.setCentralWidget(self.centralWidget)
        self.menuBar = QtGui.QMenuBar(MainWindow)
        self.menuBar.setGeometry(QtCore.QRect(0, 0, 639, 25))
        self.menuBar.setObjectName(_fromUtf8("menuBar"))
        MainWindow.setMenuBar(self.menuBar)
        self.mainToolBar = QtGui.QToolBar(MainWindow)
        self.mainToolBar.setObjectName(_fromUtf8("mainToolBar"))
        MainWindow.addToolBar(QtCore.Qt.TopToolBarArea, self.mainToolBar)
        self.statusBar = QtGui.QStatusBar(MainWindow)
        self.statusBar.setObjectName(_fromUtf8("statusBar"))
        MainWindow.setStatusBar(self.statusBar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QtGui.QApplication.translate("MainWindow", "MainWindow", None, QtGui.QApplication.UnicodeUTF8))
        self.label.setText(QtGui.QApplication.translate("MainWindow", "Select Data FIle ", None, QtGui.QApplication.UnicodeUTF8))
        self.label_2.setText(QtGui.QApplication.translate("MainWindow", "Subject Name", None, QtGui.QApplication.UnicodeUTF8))
        self.label_3.setText(QtGui.QApplication.translate("MainWindow", "Sample Size", None, QtGui.QApplication.UnicodeUTF8))
        self.label_5.setText(QtGui.QApplication.translate("MainWindow", "Remove noise :", None, QtGui.QApplication.UnicodeUTF8))
        self.label_6.setText(QtGui.QApplication.translate("MainWindow", "Feature enhancement method: ", None, QtGui.QApplication.UnicodeUTF8))
        self.label_7.setText(QtGui.QApplication.translate("MainWindow", "Classifier:", None, QtGui.QApplication.UnicodeUTF8))
        self.BrowseButton.setText(QtGui.QApplication.translate("MainWindow", "Browse", None, QtGui.QApplication.UnicodeUTF8))
        self.removeNoiseChecked.setText(QtGui.QApplication.translate("MainWindow", "yes", None, QtGui.QApplication.UnicodeUTF8))
        self.removeNoiseUnchecked.setText(QtGui.QApplication.translate("MainWindow", "no", None, QtGui.QApplication.UnicodeUTF8))
        self.TrainButton.setText(QtGui.QApplication.translate("MainWindow", "Train", None, QtGui.QApplication.UnicodeUTF8))
        self.label_8.setText(QtGui.QApplication.translate("MainWindow", "Sample Start At", None, QtGui.QApplication.UnicodeUTF8))
        self.label_9.setText(QtGui.QApplication.translate("MainWindow", "Sample End At", None, QtGui.QApplication.UnicodeUTF8))
        self.SampleStart.setHtml(QtGui.QApplication.translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:\'Ubuntu\'; font-size:11pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">0</p></body></html>", None, QtGui.QApplication.UnicodeUTF8))
        self.SampleEnd.setHtml(QtGui.QApplication.translate("MainWindow", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:\'Ubuntu\'; font-size:11pt; font-weight:400; font-style:normal;\">\n"
"<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">4</p></body></html>", None, QtGui.QApplication.UnicodeUTF8))
        self.label_10.setText(QtGui.QApplication.translate("MainWindow", "Getting features method", None, QtGui.QApplication.UnicodeUTF8))
        self.label_4.setText(QtGui.QApplication.translate("MainWindow", "Preprocessing method", None, QtGui.QApplication.UnicodeUTF8))

