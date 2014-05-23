import os
import oct2py
import AppConfig
import FeatureAnalysisConfig as FeatAConfig

from PyQt4 import QtCore, QtGui
from gui_navigate import Ui_NavigateWindow

class Ui_NavigateWindow_Extended(Ui_NavigateWindow):
    def InitializeUI(self, NavigateWindow, octave):
        # Used with closeEvent
        self.NavigateWindow = NavigateWindow
        self.getPlottingFunctions()
        
        # Octave
        
        self.octave = octave
        
        Channels = [ "FC5", "FC6", "F3", "AF3", "F7", "T7", "P7", "O1", "O2", "P8", "T8", "F8", "AF4", "F4" ]
        self.ChannelName_ComboBox.addItems(Channels)
        
        # Initializing
        self.TrialNumber    = 1
        self.NavStep        = 1
        
        #EVENTS
        self.NavigateWindow.closeEvent = self.onClose
        self.Next_Button.clicked.connect(self.Next_Button_Clicked)
        self.Prev_Button.clicked.connect(self.Prev_Button_Clicked)
        self.ChannelName_ComboBox.currentIndexChanged['QString'].connect(self.ChannelName_ComboBox_CurrentIndexChanged)
        self.PlotType_ComboBox.currentIndexChanged['QString'].connect(self.PlotType_ComboBox_CurrentIndexChanged)
    
    def Next_Button_Clicked(self):
        self.TrialNumber = self.TrialNumber + self.NavStep
        if(self.TrialNumber > 100): self.TrialNumber = 1
        self.plot()
    
    def Prev_Button_Clicked(self):
        self.TrialNumber = self.TrialNumber - self.NavStep
        if(self.TrialNumber < 1): self.TrialNumber = 100
        self.plot()
    
    def PlotType_ComboBox_CurrentIndexChanged(self):
        self.plot()    
    
    def ChannelName_ComboBox_CurrentIndexChanged(self):
        self.plot()
    
    def plot(self):
        cmd = "{0}(DataOut, {1}, '{2}');".format(self.PlotType_ComboBox.currentText(), self.TrialNumber, self.ChannelName_ComboBox.currentText())
        self.NavStep = int( self.octave.eval(cmd) )
        self.TrialNumber_Label.setText( "{0}/100".format(self.TrialNumber) )
        #TrialNumber_Label
    
    
    def getPlottingFunctions(self):
        # Get PlottingFunctions-Path
        PlottingFunctionsPath = FeatAConfig.PlottingFunctionsPath            
        
        # Get PlottingFunctions
        PlottingFunctionsFiles = os.listdir(PlottingFunctionsPath)
        
        PlottingFunctions = []
        
        for func in PlottingFunctionsFiles:
            self.PlotType_ComboBox.addItem(func.split(".")[0])
    
    def onClose(self, event):
        self.octave.eval("figure(1);close;")
