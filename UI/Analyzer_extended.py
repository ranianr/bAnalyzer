#main imports
import os
import sys
import numpy as np
import oct2py 
import thread
import signal



from Analyzer import Ui_MainWindow
from TrainingFileClass import TrainingFileClass
from threads import readDataThread

from PyQt4 import *
from PyQt4 import QtCore, QtGui


class Ui_MainWindow_Extended(Ui_MainWindow):
    def InitializeUI(self):
        self.addComboBoxesData()
	self.path=None
	
	#EVENTS
	QtCore.QObject.connect(self.BrowseButton, QtCore.SIGNAL(("clicked()")), self.browseButtonClicked) #browse button
	print(self.path)
	QtCore.QObject.connect(self.TrainButton, QtCore.SIGNAL(("clicked()")), self.TrainButton_Clicked) #train button
	signal.signal(signal.SIGINT, signal.SIG_DFL)

    def addComboBoxesData(self):
	#self.featureSelectionMethods = ("FFT", "trivial") #add methods manually !
	self.featureSelectionMethods = 'FFT' #add methods manually !
        self.featureSelectionMethods = ('FFT', "error") #add methods manually !
        
	self.featureEnhancementMethods = ("PCA","LDA","CSP") #add more feature enhancement methods manully
        
	self.classifiers = ("Fisher","KNN","Likelihood","Least Squares") #add classifiers manually !

	self.signalEnhancementMethod.clear()
	self.signalEnhancementMethod.addItems(self.featureSelectionMethods)
	self.FeatureEnhancementMethod.clear()
	self.FeatureEnhancementMethod.addItems(self.featureEnhancementMethods)
	self.ClassifierBox.clear()
	self.ClassifierBox.addItems(self.classifiers )
     
    def browseButtonClicked(self):
	self.fileDialog = QtGui.QFileDialog()
	self.path=self.getFileName()
	
	self.datafile.setText(self.path)
	self.XmlFileName = self.path
	    #read CSV files GDF files will be supported later
	Details = {}
	TrainingFileClass.getClasses(self.path)
	Details["SubjectName"]          = TrainingFileClass.getName(self.path)
	Details["Classes"]              = TrainingFileClass.getClasses(self.path)
	print(Details["SubjectName"] )
	self.subjectName.setText(Details["SubjectName"]) #subject name label
    
    #used by "browseButtonClicked" function to get the selected file path          
    def getFileName(self):
        self.path = self.fileDialog.getOpenFileName()
        print(" File Selected: ", self.path)
	return self.path	
    
    def TrainButton_Clicked(self):
	print("Training Started...")
	if(self.removeNoiseChecked.isChecked()):
	    removeNoiseFlag = 1;
	elif(self.removeNoiseUnchecked.isChecked()):
	    removeNoiseFlag = 0;
	    
	SignalEnhancementSelectedMethod  = self.signalEnhancementMethod.currentText()
	FeatureEnhancementSelectedMethod = self.FeatureEnhancementMethod.currentText()
	classifierSelected = self.ClassifierBox.currentText()
	
	#calling the octave thread
	self.readThread = readDataThread(self.path,removeNoiseFlag, SignalEnhancementSelectedMethod,FeatureEnhancementSelectedMethod, classifierSelected)
	
		#done signals calling
	#enhancment is done
	QtCore.QObject.connect(self.readThread, QtCore.SIGNAL(("dataCleaningSignal(PyQt_PyObject)")), self.cleanData)
	#feature exctraction is done
	QtCore.QObject.connect(self.readThread, QtCore.SIGNAL(("featureSelectionSignal(PyQt_PyObject)")), self.selectFeatures)
	#feature enhancement is done
	QtCore.QObject.connect(self.readThread, QtCore.SIGNAL(("featureEnhancementSignal(PyQt_PyObject)")), self.enhanceFeatures)
	#classification is done
	QtCore.QObject.connect(self.readThread, QtCore.SIGNAL(("dataClassificationSignal(PyQt_PyObject)")), self.classifyData) 

	self.readThread.start()
	
    def cleanData(self, data):
	self.done1.setText("Done!")
	self.readThread.terminate()

    def selectFeatures(self, data):
	self.done2.setText("Done2!")
	self.readThread.terminate()

    def enhanceFeatures(self, data):
	self.done3.setText("Done3!")
	self.readThread.terminate()

    def classifyData(self, data):
	self.done4.setText("Done4!")
	self.readThread.terminate()