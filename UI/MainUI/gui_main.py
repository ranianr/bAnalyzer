# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '../UI/MainUI/gui_main.ui'
#
# Created: Thu May 22 05:34:52 2014
#      by: PyQt4 UI code generator 4.10.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName(_fromUtf8("MainWindow"))
        MainWindow.resize(340, 410)
        MainWindow.setMinimumSize(QtCore.QSize(340, 410))
        MainWindow.setMaximumSize(QtCore.QSize(340, 410))
        self.centralwidget = QtGui.QWidget(MainWindow)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.DetectionOptionsGroup = QtGui.QGroupBox(self.centralwidget)
        self.DetectionOptionsGroup.setGeometry(QtCore.QRect(10, 70, 330, 140))
        self.DetectionOptionsGroup.setObjectName(_fromUtf8("DetectionOptionsGroup"))
        self.label_7 = QtGui.QLabel(self.DetectionOptionsGroup)
        self.label_7.setGeometry(QtCore.QRect(10, 30, 80, 17))
        self.label_7.setStyleSheet(_fromUtf8("font: bold;"))
        self.label_7.setObjectName(_fromUtf8("label_7"))
        self.label_6 = QtGui.QLabel(self.DetectionOptionsGroup)
        self.label_6.setGeometry(QtCore.QRect(90, 30, 60, 17))
        self.label_6.setStyleSheet(_fromUtf8("font: bold;"))
        self.label_6.setObjectName(_fromUtf8("label_6"))
        self.label_8 = QtGui.QLabel(self.DetectionOptionsGroup)
        self.label_8.setGeometry(QtCore.QRect(10, 90, 80, 17))
        self.label_8.setStyleSheet(_fromUtf8("font: bold;"))
        self.label_8.setObjectName(_fromUtf8("label_8"))
        self.label_9 = QtGui.QLabel(self.DetectionOptionsGroup)
        self.label_9.setGeometry(QtCore.QRect(90, 90, 70, 17))
        self.label_9.setStyleSheet(_fromUtf8("font: bold;"))
        self.label_9.setObjectName(_fromUtf8("label_9"))
        self.MuMin_SpinBox = QtGui.QSpinBox(self.DetectionOptionsGroup)
        self.MuMin_SpinBox.setGeometry(QtCore.QRect(10, 50, 70, 27))
        self.MuMin_SpinBox.setProperty("value", 10)
        self.MuMin_SpinBox.setObjectName(_fromUtf8("MuMin_SpinBox"))
        self.MuMax_SpinBox = QtGui.QSpinBox(self.DetectionOptionsGroup)
        self.MuMax_SpinBox.setGeometry(QtCore.QRect(90, 50, 70, 27))
        self.MuMax_SpinBox.setProperty("value", 12)
        self.MuMax_SpinBox.setObjectName(_fromUtf8("MuMax_SpinBox"))
        self.BetaMin_SpinBox = QtGui.QSpinBox(self.DetectionOptionsGroup)
        self.BetaMin_SpinBox.setGeometry(QtCore.QRect(10, 110, 70, 27))
        self.BetaMin_SpinBox.setProperty("value", 16)
        self.BetaMin_SpinBox.setObjectName(_fromUtf8("BetaMin_SpinBox"))
        self.BetaMax_SpinBox = QtGui.QSpinBox(self.DetectionOptionsGroup)
        self.BetaMax_SpinBox.setGeometry(QtCore.QRect(90, 110, 70, 27))
        self.BetaMax_SpinBox.setProperty("value", 24)
        self.BetaMax_SpinBox.setObjectName(_fromUtf8("BetaMax_SpinBox"))
        self.Plot_Button = QtGui.QPushButton(self.centralwidget)
        self.Plot_Button.setGeometry(QtCore.QRect(110, 370, 121, 27))
        self.Plot_Button.setObjectName(_fromUtf8("Plot_Button"))
        self.FilePath_LineEdit = QtGui.QLineEdit(self.centralwidget)
        self.FilePath_LineEdit.setGeometry(QtCore.QRect(20, 30, 310, 27))
        self.FilePath_LineEdit.setObjectName(_fromUtf8("FilePath_LineEdit"))
        self.label_17 = QtGui.QLabel(self.centralwidget)
        self.label_17.setGeometry(QtCore.QRect(10, 10, 131, 17))
        self.label_17.setStyleSheet(_fromUtf8("font: bold;"))
        self.label_17.setObjectName(_fromUtf8("label_17"))
        self.DetectionOptionsGroup_3 = QtGui.QGroupBox(self.centralwidget)
        self.DetectionOptionsGroup_3.setGeometry(QtCore.QRect(10, 220, 330, 80))
        self.DetectionOptionsGroup_3.setObjectName(_fromUtf8("DetectionOptionsGroup_3"))
        self.label_13 = QtGui.QLabel(self.DetectionOptionsGroup_3)
        self.label_13.setGeometry(QtCore.QRect(10, 30, 80, 17))
        self.label_13.setStyleSheet(_fromUtf8("font: bold;"))
        self.label_13.setObjectName(_fromUtf8("label_13"))
        self.label_14 = QtGui.QLabel(self.DetectionOptionsGroup_3)
        self.label_14.setGeometry(QtCore.QRect(90, 30, 60, 17))
        self.label_14.setStyleSheet(_fromUtf8("font: bold;"))
        self.label_14.setObjectName(_fromUtf8("label_14"))
        self.TimeRangeStart_SpinBox = QtGui.QSpinBox(self.DetectionOptionsGroup_3)
        self.TimeRangeStart_SpinBox.setGeometry(QtCore.QRect(10, 50, 70, 27))
        self.TimeRangeStart_SpinBox.setMinimum(-99)
        self.TimeRangeStart_SpinBox.setProperty("value", 0)
        self.TimeRangeStart_SpinBox.setObjectName(_fromUtf8("TimeRangeStart_SpinBox"))
        self.TimeRangeEnd_SpinBox = QtGui.QSpinBox(self.DetectionOptionsGroup_3)
        self.TimeRangeEnd_SpinBox.setGeometry(QtCore.QRect(90, 50, 70, 27))
        self.TimeRangeEnd_SpinBox.setProperty("value", 4)
        self.TimeRangeEnd_SpinBox.setObjectName(_fromUtf8("TimeRangeEnd_SpinBox"))
        self.RemoveNoise_CheckBox = QtGui.QCheckBox(self.centralwidget)
        self.RemoveNoise_CheckBox.setGeometry(QtCore.QRect(10, 320, 130, 22))
        self.RemoveNoise_CheckBox.setChecked(True)
        self.RemoveNoise_CheckBox.setObjectName(_fromUtf8("RemoveNoise_CheckBox"))
        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)
        MainWindow.setTabOrder(self.Plot_Button, self.FilePath_LineEdit)
        MainWindow.setTabOrder(self.FilePath_LineEdit, self.MuMin_SpinBox)
        MainWindow.setTabOrder(self.MuMin_SpinBox, self.MuMax_SpinBox)
        MainWindow.setTabOrder(self.MuMax_SpinBox, self.BetaMin_SpinBox)
        MainWindow.setTabOrder(self.BetaMin_SpinBox, self.BetaMax_SpinBox)
        MainWindow.setTabOrder(self.BetaMax_SpinBox, self.TimeRangeStart_SpinBox)
        MainWindow.setTabOrder(self.TimeRangeStart_SpinBox, self.TimeRangeEnd_SpinBox)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(_translate("MainWindow", "Feature Analysis", None))
        self.DetectionOptionsGroup.setTitle(_translate("MainWindow", "Frequency Range", None))
        self.label_7.setText(_translate("MainWindow", "<html><head/><body><p>Mu Min</p></body></html>", None))
        self.label_6.setText(_translate("MainWindow", "<html><head/><body><p>Mu Max</p></body></html>", None))
        self.label_8.setText(_translate("MainWindow", "<html><head/><body><p>Beta Min</p></body></html>", None))
        self.label_9.setText(_translate("MainWindow", "<html><head/><body><p>Beta Max</p></body></html>", None))
        self.Plot_Button.setText(_translate("MainWindow", "Plot", None))
        self.FilePath_LineEdit.setText(_translate("MainWindow", "/home/rho/Documents/GP/[2014-03-23] Braingizer/Data/TrainingData/Session_2014_04_17_82423/[T][2014-04-17 23-06-15] Ahmed Hemaly.csv", None))
        self.label_17.setText(_translate("MainWindow", "<html><head/><body><p>Training File</p></body></html>", None))
        self.DetectionOptionsGroup_3.setTitle(_translate("MainWindow", "Time Range", None))
        self.label_13.setText(_translate("MainWindow", "<html><head/><body><p>Start</p></body></html>", None))
        self.label_14.setText(_translate("MainWindow", "<html><head/><body><p>End</p></body></html>", None))
        self.RemoveNoise_CheckBox.setText(_translate("MainWindow", "Remove Noise", None))

