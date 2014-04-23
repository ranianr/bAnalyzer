import os
import sys
import numpy as np
import oct2py 
import thread
from PyQt4 import QtCore, QtGui
class readDataThread(QtCore.QThread):
    def __init__(self,  dataFile,removeNoiseFlag,SignalStart, SignalEnd, selectedFeatureExtractionMethod,selectedPreprocessingMethod,FeatureEnhancementSelectedMethod, classifierSelected):
        QtCore.QThread.__init__(self)
        self.path = dataFile
        #write any initialization here
        self.dataFile = dataFile
        self.removeNoiseFlag = removeNoiseFlag
        self.SignalStart = SignalStart
        self.SignalEnd = SignalEnd
        self.selectedFeatureExtractionMethod = selectedFeatureExtractionMethod
	self.selectedPreprocessingMethod = selectedPreprocessingMethod
	self.FeatureEnhancementSelectedMethod = FeatureEnhancementSelectedMethod
        self.classifierFile = classifierFile

    def featureMerger(self, features, count, direction):
        if (direction == 'H'): #horizontal merging
            if (count == 2):
               return np.r_[features[0], features[1]]
            if (count == 3):
               return np.r_[features[0], features[1], features[2]]
            if (count == 4):
               return np.r_[features[0], features[1], features[2], features[3]]
            if (count == 5):
               return np.r_[features[0], features[1], features[2], features[3], features[4]]
        elif (direction == 'V'): #vertical merging
            if (count == 2):
                return np.c_[features[0], features[1]]
            if (count == 3):
                return np.c_[features[0], features[1], features[2]]
            if (count == 4):
                return np.c_[features[0], features[1], features[2], features[3]]
            if (count == 5):
                return np.c_[features[0], features[1], features[2], features[3], features[4]]

    def getClassNumbers(self, HDR, classTags):
        octave = oct2py.Oct2Py()
        octave.addpath('Octave')
        labels = list()
        for tag in classTags:
             labels.append(octave.call('getClassNumber.m', HDR, tag))
        return labels

    def run(self): 
        octave = oct2py.Oct2Py()
        octave.addpath('Octave')	
        
        ####read the data from the file give in "dataFile"
        rawData = {}
        rawData["Data"], rawData["HDR"] = octave.call('getRawData.m', str(self.dataFile))
	
	####check the "removeNoiseFlag" and perform action
	if(self.removeNoiseFlag):
	    rawData["Data"] = octave.call('remove_noise.m',rawData["Data"])
	    #self.emit( QtCore.SIGNAL('dataCleaningSignal(PyQt_PyObject)'), rawData["Data"])#data enhancment signal 

	####check the feature extraction method then execute it
	#FFT
	if (str(self.featureExtractionmeFile) == "FFT" ):
	    features = []
	    first_feature, second_feature = octave.call('GetMuBeta.m', rawData["Data"], rawData["HDR"])
	    features.append(first_feature)
	    features.append(second_feature)	    
    	    print("FFT done!")
	elif (str(self.featureExtractionmeFile) == "error" ):
	    pass
	#self.emit( QtCore.SIGNAL('featureSelectionSignal(PyQt_PyObject)'), features)#fetaure extraction signal 
	
	
	####Feature enhancement
	#PCA
	if (str(self.featureEnhancementMethod) == "PCA" ):
	    pcaOutput = {}
	    features_count = 2
	    featuresMerged =  self.featureMerger(features, features_count, 'V')
	    pcaOutput["eigVal"], pcaOutput["projected"] = octave.call('pcaProject.m', featuresMerged)
	    print("PCA done!")
	#LDA
	elif (str(self.featureEnhancementMethod) == "LDA" ):
	    ldaOutput ={}

	    features_count = 2
	    featuresMerged =  self.featureMerger(features, features_count, 'V')

	    #NOT TRUE: use "getClassNumber" function to get the class number
	    #classes_no = [ getClassNumber(HDR,'RIGHT')  getClassNumber(HDR,'LEFT') ];
	    classTags = ["RIGHT", "LEFT"]
	    
	    unique_classes = self.getClassNumbers(rawData["HDR"], classTags)
	    print unique_classes
	    #please ensure we're sending the right parameters -- not right :/
	    #print(rawData["HDR"].Classlabel)
	    print len(featuresMerged)
	    ldaOutput["projected"], ldaOutput["projMatrix"] = octave.call('LDA_fn.m', rawData["HDR"].Classlabel, featuresMerged, unique_classes)
	    print("LDA !")
	
	#CSP
	elif (str(self.featureEnhancementMethod) == "CSP" ):#preprocessing
	    print("CSP !")
	#self.emit( QtCore.SIGNAL('featureEnhancementSignal(PyQt_PyObject)'), features)#feature enhancement signal 	    
	
	
	####check the classifier and return the classification result
	if (str(self.classifierFile) == "KNN" ):
	    accuracy, k_total = octave.call('knnResults.m',  pcaOutput["projected"].T, rawData["HDR"]["Classlabel"])
	    
	    AccIndex = accuracy.argmax()
	    #TODO: check results with octave (K)
	    print("KNN !-------- k index" + str(AccIndex))
	    print("KNN !-------- k" + str(k_total[AccIndex])) #check the typr of K 
	    print("KNN !")
	    print("KNN Summary:- \r\n")
	    #the accuracy is a row vector
	    print("accuracy: " +  str(accuracy))
	    #the k is a column vector of the features number
	    print("K total: " +  str(k_total.T))

	elif (str(self.classifierFile) == "Fisher" ):
	    accuracy, w_temp, wo_temp= octave.call('FisherResults.m', pcaOutput["projected"].T, rawData["HDR"]["Classlabel"])
	    
	    print("Fisher !")
	    print("Fisher Summary:-\r\n")
	    #the accuracy is a matrix
	    print("accuracy: " + str(accuracy.T))
	    print("w_temp: " + str(w_temp.T))
	    print("wo_temp: " + str(wo_temp.T))
	    
	elif (str(self.classifierFile) == "Likelihood" ):
	    accuracy = octave.call('likelihoodResults.m', pcaOutput["projected"].T, rawData["HDR"]["Classlabel"])

	    print("Likelihood !")
	    print("Likelihood Summary:-\r\n")
	    #the accuracy is a row vector
	    print("accuracy: " + str(accuracy))

	elif (str(self.classifierFile) == "Least Squares" ):
	    accuracy = octave.call('leastSquaresResults.m', pcaOutput["projected"].T, rawData["HDR"]["Classlabel"])
	    
	    print("Least squares !")
	    print("Least Squares Summary:-\r\n")
	    #the accuracy is a column vector
	    print("accuracy: " + str(accuracy.T))
	    
	#self.emit( QtCore.SIGNAL('dataClassificationSignal(PyQt_PyObject)'), features)#classifier signal 