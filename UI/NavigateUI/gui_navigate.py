# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '../UI/NavigateUI/gui_navigate.ui'
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

class Ui_NavigateWindow(object):
    def setupUi(self, NavigateWindow):
        NavigateWindow.setObjectName(_fromUtf8("NavigateWindow"))
        NavigateWindow.resize(340, 130)
        NavigateWindow.setMinimumSize(QtCore.QSize(340, 130))
        NavigateWindow.setMaximumSize(QtCore.QSize(340, 130))
        self.centralwidget = QtGui.QWidget(NavigateWindow)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.label_2 = QtGui.QLabel(self.centralwidget)
        self.label_2.setGeometry(QtCore.QRect(10, 90, 110, 20))
        self.label_2.setStyleSheet(_fromUtf8("font: bold;"))
        self.label_2.setObjectName(_fromUtf8("label_2"))
        self.ChannelName_ComboBox = QtGui.QComboBox(self.centralwidget)
        self.ChannelName_ComboBox.setGeometry(QtCore.QRect(120, 90, 100, 27))
        self.ChannelName_ComboBox.setObjectName(_fromUtf8("ChannelName_ComboBox"))
        self.label_3 = QtGui.QLabel(self.centralwidget)
        self.label_3.setGeometry(QtCore.QRect(10, 60, 110, 20))
        self.label_3.setStyleSheet(_fromUtf8("font: bold;"))
        self.label_3.setObjectName(_fromUtf8("label_3"))
        self.PlotType_ComboBox = QtGui.QComboBox(self.centralwidget)
        self.PlotType_ComboBox.setGeometry(QtCore.QRect(120, 60, 210, 27))
        self.PlotType_ComboBox.setObjectName(_fromUtf8("PlotType_ComboBox"))
        self.Prev_Button = QtGui.QPushButton(self.centralwidget)
        self.Prev_Button.setGeometry(QtCore.QRect(60, 10, 30, 30))
        font = QtGui.QFont()
        font.setPointSize(14)
        font.setBold(True)
        font.setItalic(True)
        font.setWeight(75)
        self.Prev_Button.setFont(font)
        self.Prev_Button.setObjectName(_fromUtf8("Prev_Button"))
        self.Next_Button = QtGui.QPushButton(self.centralwidget)
        self.Next_Button.setGeometry(QtCore.QRect(250, 10, 30, 30))
        font = QtGui.QFont()
        font.setPointSize(14)
        font.setBold(True)
        font.setItalic(True)
        font.setWeight(75)
        self.Next_Button.setFont(font)
        self.Next_Button.setObjectName(_fromUtf8("Next_Button"))
        self.TrialNumber_Label = QtGui.QLabel(self.centralwidget)
        self.TrialNumber_Label.setGeometry(QtCore.QRect(100, 10, 140, 30))
        self.TrialNumber_Label.setAlignment(QtCore.Qt.AlignCenter)
        self.TrialNumber_Label.setObjectName(_fromUtf8("TrialNumber_Label"))
        self.line = QtGui.QFrame(self.centralwidget)
        self.line.setGeometry(QtCore.QRect(10, 50, 320, 3))
        self.line.setFrameShape(QtGui.QFrame.HLine)
        self.line.setFrameShadow(QtGui.QFrame.Sunken)
        self.line.setObjectName(_fromUtf8("line"))
        NavigateWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(NavigateWindow)
        QtCore.QMetaObject.connectSlotsByName(NavigateWindow)
        NavigateWindow.setTabOrder(self.Next_Button, self.Prev_Button)
        NavigateWindow.setTabOrder(self.Prev_Button, self.PlotType_ComboBox)
        NavigateWindow.setTabOrder(self.PlotType_ComboBox, self.ChannelName_ComboBox)

    def retranslateUi(self, NavigateWindow):
        NavigateWindow.setWindowTitle(_translate("NavigateWindow", "Feature Analysis - Navigation", None))
        self.label_2.setText(_translate("NavigateWindow", "<html><head/><body><p>Channel Name</p></body></html>", None))
        self.label_3.setText(_translate("NavigateWindow", "<html><head/><body><p>Plot Type</p></body></html>", None))
        self.Prev_Button.setText(_translate("NavigateWindow", "←", None))
        self.Next_Button.setText(_translate("NavigateWindow", "→", None))
        self.TrialNumber_Label.setText(_translate("NavigateWindow", "1/100", None))

