import os
import oct2py
import AppConfig

from PyQt4 import QtCore, QtGui
from gui_main import Ui_MainWindow
from gui_navigate_extended import Ui_NavigateWindow_Extended

class Ui_MainWindow_Extended(Ui_MainWindow):
    def InitializeUI(self, MainWindow, app):
        # Used with MessageBoxes and closeEvent
        self.MainWindow = MainWindow
        
        #Used in exit
        self.app = app
        
        #Octave
        self.octave = oct2py.Oct2Py()
        self.octave.call('addpath', AppConfig.ScrpitsFolder)
        self.octave.call('addpath', AppConfig.PlottingFunctionsPath)
        
        #Navigate Window
        self.NavigateWindow = QtGui.QMainWindow()
        self.ui_navigate = Ui_NavigateWindow_Extended()
        self.ui_navigate.setupUi(self.NavigateWindow)
        self.ui_navigate.InitializeUI(self.NavigateWindow, self.octave)
        
        #EVENTS
        self.MainWindow.closeEvent = self.onClose
        self.Plot_Button.clicked.connect(self.Plot_Button_Clicked)
    
    def Plot_Button_Clicked(self):
        Parameters = oct2py.Struct()
        
        FilePath    = self.FilePath_LineEdit.text()
        RawPath     = AppConfig.RawDataFunctions
        Mu_Min      = self.MuMin_SpinBox.value()
        Mu_Max      = self.MuMax_SpinBox.value()
        
        Beta_Min    = self.BetaMin_SpinBox.value()
        Beta_Max    = self.BetaMax_SpinBox.value()
        
        Time_Min    = self.TimeRangeStart_SpinBox.value()
        Time_Max    = self.TimeRangeEnd_SpinBox.value()
        
        if(self.RemoveNoise_CheckBox.isChecked()):
            RemoveNoise = 'true'
        else:
            RemoveNoise = 'false'
        
        cmd = "DataOut = GetDataAnalysis('{0}', '{1}', {2}, {3}, {4}, {5}, {6}, {7}, {8});".format(FilePath, RawPath, Mu_Min, Mu_Max, Beta_Min, Beta_Max, Time_Min, Time_Max, RemoveNoise)
        self.octave.eval(cmd)
        
        self.NavigateWindow.show()
        self.ui_navigate.plot()
    
    def showMessageBox(self, title, message):
        reply = QtGui.QMessageBox.about(self.MainWindow, title, message)
    
    def showQuestionMessageBox(self, title, message):
        reply = QtGui.QMessageBox.question(self.MainWindow, title, message,
                                           QtGui.QMessageBox.Yes |
                                           QtGui.QMessageBox.No, QtGui.QMessageBox.No)
        if reply == QtGui.QMessageBox.No:
            return False
        else:
            return True
    
    def onClose(self, event):
        self.octave.close()
        self.app.exit()