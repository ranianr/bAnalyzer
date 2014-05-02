import os
import sys
import numpy as np
import oct2py 
import thread
from PyQt4 import QtCore, QtGui
class DetectThread(QtCore.QThread):
    def __init__(self,  dataFile,removeNoiseFlag,SignalStart, SignalEnd, selectedFeatureExtractionMethod,selectedPreprocessingMethod,FeatureEnhancementSelectedMethod, classifierSelected):
        QtCore.QThread.__init__(self)
        self.path = dataFile
        #write any initialization here
        self.dataFile = str(dataFile)
        self.removeNoiseFlag = removeNoiseFlag
        self.SignalStart = int(SignalStart)
        self.SignalEnd = int(SignalEnd)
        self.selectedFeatureExtractionMethod = selectedFeatureExtractionMethod
	self.selectedPreprocessingMethod = selectedPreprocessingMethod
	self.FeatureEnhancementSelectedMethod = FeatureEnhancementSelectedMethod
        self.classifierFile = classifierSelected

    def run(self): 
        octave = oct2py.Oct2Py()
        octave.addpath('octave2')
	#"../Osama Mohamed.csv",1,1,0,0,0,0,0,0,1,0,0,0,4
	
	
	#TrainOut = KNN_Generic(directory, noiseFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,CSPFlag,startD,endD)

	#settig the feature selection method flags
	if(self.selectedFeatureExtractionMethod =="mean"):
	    self.f1FLag = 1
	else:
	    self.f1FLag = 0
	if(self.selectedFeatureExtractionMethod =="Min MU and Max Beta"):
	    self.f3FLag = 1
	else:
	    self.f3FLag = 0
	if(self.selectedFeatureExtractionMethod =="Min Mu, Max Beta, Mean Mu, Mean Beta"):
	    self.f4FLag = 1
	else:
	    self.f4FLag = 0
	if(self.selectedFeatureExtractionMethod =="Min Mu Max Mu Min Beta Max Beta"):
	    self.f5FLag = 1
	else:
	    self.f5FLag = 0
	if(self.selectedFeatureExtractionMethod =="Min Mu, max Mu, Min Beta, Max Beta, Mean Mu, Mean Beta"):
	    self.f6FLag = 1
	else:
	    self.f6FLag = 0
	
	#preprocessing is not done yet    
	if(self.selectedPreprocessingMethod == ""):
	    pass

	#setting the feature enhancement flags 
	if(self.FeatureEnhancementSelectedMethod == "PCA"):
	    self.PCAFlag = 1
	else:
	    self.PCAFlag = 0
	if(self.FeatureEnhancementSelectedMethod == "LDA"):
	    self.LDAFlag = 1
	else:
	    self.LDAFlag = 0
	if(self.FeatureEnhancementSelectedMethod == "CSP"):
	    self.CSPFlag = 1
	else:
	    self.CSPFlag = 0
	    
	#unused flags for now
	self.CSP_LDAFlag =0
	self.f2FLag =0
	
	#define the output structures
	self.knnTrainOut = oct2py.Struct()
	self.fisherTrainOut = oct2py.Struct()
	self.leastSquaresTrainOut = oct2py.Struct()
	self.likelihoodTrainOut = oct2py.Struct()
	
	#calling the classifer selected according     
        if(self.classifierFile == "KNN"):
	    self.knnTrainOut = octave.call('KNN_Generic.m', self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag,self.SignalStart,self.SignalEnd)
	    print("KNN training done!")
	    
	    ###>--- using either of them is ok for debugging ---<###
	    #print(self.knnTrainOut.KPCA)
	    #print(self.knnTrainOut['KPCA'])

	elif (self.classifierFile == "Fisher"):
	    self.fisherTrainOut = octave.call('Fisher_Generic.m', self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag,self.SignalStart,self.SignalEnd)
	    print("Fisher training done!")

	elif(self.classifierFile == "Likelihood"):
	    self.likelihoodTrainOut = octave.call('Likelihood_Generic.m', self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag,self.SignalStart,self.SignalEnd)
	    print("Likelihood training done!")

	elif(self.classifierFile == "Least Squares"):
	    self.leastSquaresTrainOut = octave.call('Leastsquares_Generic.m', self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag,self.SignalStart,self.SignalEnd)
	    print("Least Square training done!")
