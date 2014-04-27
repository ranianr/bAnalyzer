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
	
	QtCore.QObject.connect(self.TrainButton, QtCore.SIGNAL(("clicked()")), self.TrainButton_Clicked) #train button
	signal.signal(signal.SIGINT, signal.SIG_DFL)

    def addComboBoxesData(self):
	#self.featureSelectionMethods = ("FFT", "trivial") #add methods manually !
	self.getFeaturesMethods = ("mean", "Min MU and Max Beta","Min Mu, Max Beta, Mean Mu, Mean Beta","Min Mu Max Mu Min Beta Max Beta","Min Mu, max Mu, Min Beta, Max Beta, Mean Mu, Mean Beta")
	self.featureSelectionMethodBox.addItems(self.getFeaturesMethods)
        
	self.preprocessingBoxContent = ("method1","method2")
	self.preprocessingBox.addItems(self.preprocessingBoxContent)
	
	self.featureEnhancementMethods = ("PCA","LDA","CSP")
	self.FeatureEnhancementMethod.addItems(self.featureEnhancementMethods)
        
	self.classifiers = ("Fisher","KNN","Likelihood","Least Squares") #add classifiers manually !
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
	self.subjectName.setText(Details["SubjectName"]) #subject name label
    
    #used by "browseButtonClicked" function to get the selected file path          
    def getFileName(self):
        self.path = self.fileDialog.getOpenFileName()
	return self.path	
    
    def TrainButton_Clicked(self):
	print("Training Started...")
	if(self.removeNoiseChecked.isChecked()):
	    removeNoiseFlag = 1;
	elif(self.removeNoiseUnchecked.isChecked()):
	    removeNoiseFlag = 0;
	SignalStart = self.SampleStart.toPlainText()
	SignalEnd   = self.SampleEnd.toPlainText()
	selectedFeatureExtractionMethod  = self.featureSelectionMethodBox.currentText()
	selectedPreprocessingMethod  = self.preprocessingBox.currentText()
	FeatureEnhancementSelectedMethod = self.FeatureEnhancementMethod.currentText()
	classifierSelected = self.ClassifierBox.currentText()
	
	#calling the octave thread
	self.readThread = readDataThread(self.path,removeNoiseFlag,SignalStart, SignalEnd, selectedFeatureExtractionMethod,selectedPreprocessingMethod,FeatureEnhancementSelectedMethod, classifierSelected)
	
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
	self.label_11.setText("Done!")
	self.readThread.terminate()

    def selectFeatures(self, data):
	self.label_12.setText("Done2!")
	self.readThread.terminate()

    def enhanceFeatures(self, data):
	self.label_14.setText("Done3!")
	self.readThread.terminate()

    def classifyData(self, data):
	self.label_13.setText("Done4!")
	self.readThread.terminate()