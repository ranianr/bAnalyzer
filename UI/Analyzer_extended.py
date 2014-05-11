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
import AppConfig

from PyQt4 import *
from PyQt4 import QtCore, QtGui

class Ui_MainWindow_Extended(Ui_MainWindow):

    def SetGUIOptionsByAppConfig(self):

	#PS: we're overwriting both the internal values and GUI fields
	# train file path
        self.trainFilePath = AppConfig.TrainingFile
	self.datafile.setText(self.trainFilePath)

	# detectFilePath
	if (AppConfig.SameFileFlag == False):
            self.detectFilePath = AppConfig.DetectionFile
	    self.DetectDataFile.setText(self.detectFilePath)

	# trial options
	self.SignalStart = AppConfig.SampleStart
	self.SampleStart.setText(str(AppConfig.SampleStart))

	self.SignalEnd = AppConfig.SampleEnd
	self.SampleEnd.setText(str(AppConfig.SampleEnd))

	# noise removal
	self.removeNoiseFlag = AppConfig.NoiseRemoval
	if (AppConfig.NoiseRemoval):
	    self.removeNoiseChecked.setChecked(True)
	else:
	    self.removeNoiseUnchecked.setChecked(True)

	# extraction method
	#TODO fix the naming convention
	self.selectedFeatureExtractionMethod = AppConfig.ExtractionMethod
	self.featureSelectionMethodBox.setCurrentIndex(AppConfig.ExtractionMethod)

	# enhancement method
	self.FeatureEnhancementSelectedMethod = AppConfig.FeatureEnhancementMethod
	self.FeatureEnhancementMethod.setCurrentIndex(AppConfig.FeatureEnhancementMethod)

	# classification method
	self.classifierSelected = AppConfig.ClassificationMethod
	self.ClassifierBox.setCurrentIndex(AppConfig.ClassificationMethod)

	# preprocessing method
	self.selectedPreprocessingMethod = AppConfig.PreprocessingMethod
	self.preprocessingBox.setCurrentIndex(AppConfig.PreprocessingMethod)

	# detection source file
	self.setSameFileFlag(AppConfig.SameFileFlag)
	self.sameFileFlag.setChecked(AppConfig.SameFileFlag)

	# same file options
	#set only the GUI, as we get the internal values from the GUI directly everytime!
	self.allData2080.setChecked(AppConfig.All)

	self.offset_0_2080.setChecked(AppConfig.Offset0)
	self.offset_1_2080.setChecked(AppConfig.Offset1)
	self.offset_2_2080.setChecked(AppConfig.Offset2)
	self.offset_3_2080.setChecked(AppConfig.Offset3)
	self.offset_4_2080.setChecked(AppConfig.Offset4)

    def InitializeUI(self):
        self.addComboBoxesData()
	self.SetGUIOptionsByAppConfig()
	#EVENTS
	#detectionBrowseButton
	
	QtCore.QObject.connect(self.BrowseButton, QtCore.SIGNAL(("clicked()")), self.browseButtonClicked) #Train browse button
	
	QtCore.QObject.connect(self.TrainButton, QtCore.SIGNAL(("clicked()")), self.TrainButton_Clicked) #Train button
	
	QtCore.QObject.connect(self.detectionBrowseButton, QtCore.SIGNAL(("clicked()")), self.testBrowseButtonClicked) #Test browse button
	
	QtCore.QObject.connect(self.testButton, QtCore.SIGNAL(("clicked()")), self.TestButton_Clicked) #Test button
	
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
	self.trainFilePath=self.getFileName()
	
	self.datafile.setText(self.trainFilePath)
	# deprecated
	self.XmlFileName = self.trainFilePath
	    #read CSV files GDF files will be supported later
	Details = {}
	TrainingFileClass.getClasses(self.trainFilePath)
	Details["SubjectName"]          = TrainingFileClass.getName(self.trainFilePath)
	Details["Classes"]              = TrainingFileClass.getClasses(self.trainFilePath)
	self.subjectName.setText(Details["SubjectName"]) #subject name label
    
    def testBrowseButtonClicked(self):
	self.fileDialog = QtGui.QFileDialog()
	self.detectFilePath = self.getFileName()
	print self.detectFilePath 
	self.DetectDataFile.setText(self.detectFilePath)
	# deprecated
	self.XmlFileName = self.detectFilePath
	    #read CSV files GDF files will be supported later
	Details = {}
	TrainingFileClass.getClasses(self.detectFilePath)
	Details["SubjectName"]          = TrainingFileClass.getName(self.detectFilePath)
	Details["Classes"]              = TrainingFileClass.getClasses(self.detectFilePath)
	self.testDataSubjectName.setText(Details["SubjectName"]) #subject name label
    
    def TestButton_Clicked(self):
	#check all files flag then offset else read from new file
	selectedData={}
	self.setSameFileFlag(self.sameFileFlag.isChecked())

	if(self.sameFile):

	    selectedData["All"] = False
	    selectedData["off0"] = False
	    selectedData["off1"] = False
	    selectedData["off2"] = False
	    selectedData["off3"] = False
	    selectedData["off4"] = False

	    if(self.allData2080.isChecked()):
		 selectedData["All"] = True
	    elif(self.offset_0_2080.isChecked()):
		 selectedData["off0"] = True
	    elif(self.offset_1_2080.isChecked()):
		 selectedData["off1"] = True
	    elif(self.offset_2_2080.isChecked()):
		 selectedData["off2"] = True
	    elif(self.offset_3_2080.isChecked()):
		 selectedData["off3"] = True
	    elif(self.offset_4_2080.isChecked()):
		 selectedData["off4"] = True

	    self.detectFilePath = None

	else:
	    print("Detection from a different file than training")

	self.readThread1 = readDataThread(self.trainFilePath, self.detectFilePath, self.removeNoiseFlag, self.SignalStart, self.SignalEnd, self.selectedFeatureExtractionMethod, self.selectedPreprocessingMethod, self.FeatureEnhancementSelectedMethod, self.classifierSelected, False, selectedData, self.sameFile)
	self.readThread1.start()

    
    #used by "browseButtonClicked" function to get the selected file path          
    def getFileName(self):
        return self.fileDialog.getOpenFileName()
    
    def TrainButton_Clicked(self):

	print("Training Started...")
	if(self.removeNoiseChecked.isChecked()):
	    self.removeNoiseFlag = 1;
	elif(self.removeNoiseUnchecked.isChecked()):
	    self.removeNoiseFlag = 0;
	self.SignalStart = self.SampleStart.toPlainText()
	self.SignalEnd   = self.SampleEnd.toPlainText()
	self.selectedFeatureExtractionMethod  = self.featureSelectionMethodBox.currentText()
	self.selectedPreprocessingMethod  = self.preprocessingBox.currentText()
	self.FeatureEnhancementSelectedMethod = self.FeatureEnhancementMethod.currentText()
	self.classifierSelected = self.ClassifierBox.currentText()
	
	#calling the octave thread
	self.readThread = readDataThread(self.trainFilePath, None, self.removeNoiseFlag, self.SignalStart, self.SignalEnd, self.selectedFeatureExtractionMethod, self.selectedPreprocessingMethod, self.FeatureEnhancementSelectedMethod, self.classifierSelected, True)
	
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

    def setSameFileFlag(self, val):
	self.sameFile = val
