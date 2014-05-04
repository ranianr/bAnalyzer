import os
import sys
import numpy as np
import oct2py 
import thread
from PyQt4 import QtCore, QtGui

#check http://stackoverflow.com/questions/2827623/python-create-object-and-add-attributes-to-it
class Object(object):
    pass

class readDataThread(QtCore.QThread):
    def __init__(self,  dataFile,removeNoiseFlag,SignalStart, SignalEnd, selectedFeatureExtractionMethod,selectedPreprocessingMethod,FeatureEnhancementSelectedMethod, classifierSelected, trainTestFlag = True, selectedData=None, sameFile = True):
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
	self.selectedData = selectedData
	self.trainTestFlag = trainTestFlag
	self.dataLength = 0
	self.LDAData = []
	self.PCAData = []
        self.octave = oct2py.Oct2Py()
        self.octave.addpath('octave2')
	self.sameFile = sameFile

    def run(self): 
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
	
	
	self.knnResult = oct2py.Struct()
	self.knnResultInput = oct2py.Struct()
	
	self.fisherResult = oct2py.Struct()
	self.fisherResultInput = oct2py.Struct()

	self.likelihoodResult = oct2py.Struct()
	self.likelihoodResultInput = oct2py.Struct()

	self.leastSquaresResult = oct2py.Struct()
	self.leastSquaresResultInput = oct2py.Struct()
	
	
	#calling the classifer selected according
	#if (self.trainTestFlag == True):

	if(self.classifierFile == "KNN"):
	    self.knnTrainOut = self.octave.call('KNN_Generic.m', self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag,self.SignalStart,self.SignalEnd)
	    self.LDAData = self.knnTrainOut.LDAData
	    self.PCAData = self.knnTrainOut.PCAData
	    self.dataLength = self.knnTrainOut.datalength
	    print("KNN training done!")
	    
	    ###>--- using either of them is ok for debugging ---<###
	    #print(self.knnTrainOut.KPCA)
	    #print(self.knnTrainOut['KPCA'])

	elif (self.classifierFile == "Fisher"):
	    self.fisherTrainOut = self.octave.call('Fisher_Generic.m', self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag,self.SignalStart,self.SignalEnd)
	    self.LDAData = self.fisherTrainOut.LDAData
	    self.PCAData = self.fisherTrainOut.PCAData
	    self.dataLength = self.fisherTrainOut.datalength
	    print("Fisher training done!")
    
	elif(self.classifierFile == "Likelihood"):
	    self.likelihoodTrainOut = self.octave.call('Likelihood_Generic.m', self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag,self.SignalStart,self.SignalEnd)
	    self.LDAData = self.likelihoodTrainOut.LDAData
	    self.PCAData = self.likelihoodTrainOut.PCAData
	    self.dataLength = self.likelihoodTrainOut.datalength
	    print("Likelihood training done!")
    
	elif(self.classifierFile == "Least Squares"):
	    self.leastSquaresTrainOut = self.octave.call('Leastsquares_Generic.m', self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag,self.SignalStart,self.SignalEnd)
	    self.LDAData = self.leastSquaresTrainOut.LDAData
	    self.PCAData = self.leastSquaresTrainOut.PCAData
	    self.dataLength = self.leastSquaresTrainOut.datalength
	    print("Least Square training done!")
	
	    
	if (self.trainTestFlag == False):
	    self.detectData()
    
    def getIndexFromTo(self):
	selD = self.selectedData;
	trialnum = int(self.dataLength)
	print trialnum
	window = 0.2 * trialnum

	index = Object()
	if (self.sameFile == True):
	    if(selD["All"] == True):
		index.start = 0
		index.end = trialnum
		return index
		
	    elif(selD["off0"] == True):
		index.start = 0
		index.end = window
		return index
	    elif(selD["off1"] == True):
		index.start = 0.2 * trialnum
		index.end = index.start + window
		return index
	    elif(selD["off2"] == True):
		index.start = 0.4 * trialnum
		index.end = index.start + window
		return index
	    elif(selD["off3"] == True):
		index.start = 0.6 * trialnum
		index.end = index.start + window
		return index
	    elif(selD["off4"] == True):
		index.start = 0.8 * trialnum
		index.end = trialnum #forced in case we have a missing final trial
		return index
	else:
	    #take the whole file in case its a new one
	    index.start = 0
	    index.end = trialnum
    
    def detectData(self):
	cf = self.classifierFile
	self.setPreProjectedFlag()
	index = self.getIndexFromTo()
	indexWindow = index.end - index.start
	if (cf == "KNN"):
	    trialsUnderTest = self.captureTrialData(index)
	    self.knnResultInput["TrainOut"] =  self.knnTrainOut

	    for i in range (int(indexWindow)):
		self.knnResultInput["TrialData"] = trialsUnderTest[i]
		self.knnResult = self.octave.call('KNN_Generic_Detect.m',self.knnResultInput,  self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag, self.preProjectedFlag)
		print self.knnResult.PCAresult
		print self.knnResult.LDAresult		
		print "trial " + str(i) + " passed ;)"
	    
	elif (cf == "Fisher"):
	    trialsUnderTest = self.captureTrialData(index)
	    self.fisherResultInput["TrainOut"] =  self.fisherTrainOut

	    for i in range (int(indexWindow)):
		self.fisherResultInput["TrialData"] = trialsUnderTest[i]
		self.fisherResult = self.octave.call('Fisher_Generic_Detect.m',self.fisherResultInput,  self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag, self.preProjectedFlag)
		print self.fisherResult.PCAresult
		print self.fisherResult.LDAresult
		print "trial " + str(i) + " passed ;)"
	    
	elif (cf == "Likelihood"):
	    trialsUnderTest = self.captureTrialData(index)
	    self.likelihoodResultInput["TrainOut"] =  self.likelihoodTrainOut

	    for i in range (int(indexWindow)):
		self.likelihoodResultInput["TrialData"] = trialsUnderTest[i]
		self.likelihoodResult = self.octave.call('Likelihood_Generic_Detect.m',self.likelihoodResultInput,  self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag, self.preProjectedFlag)
		print self.likelihoodResult.PCAresult
		print self.likelihoodResult.LDAresult		
		print "trial " + str(i) + " passed ;)"
	    
	elif (cf == "Least Squares"):
	    trialsUnderTest = self.captureTrialData(index)
	    self.leastSquaresResultInput["TrainOut"] =  self.leastSquaresTrainOut

	    for i in range (int(indexWindow)):
		self.leastSquaresResultInput["TrialData"] = trialsUnderTest[i]
		self.leastSquaresResult = self.octave.call('Leastsquares_Generic_Detect.m',self.leastSquaresResultInput,  self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag, self.preProjectedFlag)
		print self.leastSquaresResult.PCAresult
		print self.leastSquaresResult.LDAresult		
		print "trial " + str(i) + " passed ;)"
    
    def  captureTrialData(self, index):
	if(self.LDAFlag == 1):
	    ## use the following to test the dimensions we get for each trial!
	    ## our first ref was 20x28
	    #temp = self.LDAData[index.start:index.end]
	    #print temp.shape
	    return self.LDAData[index.start:index.end]
	if(self.PCAFlag == 1):
	    #notice that giving an upper index higher than the available no of elements, would clamp to the the number of elements
	    return self.PCAData[index.start:index.end]

    def setPreProjectedFlag(self):
	if (self.sameFile):
	    self.preProjectedFlag = 1
	else:
	    self.preProjectedFlag = 0