import os
import sys
import numpy as np
import oct2py 
import thread
from PyQt4 import QtCore, QtGui

from AccuracyStats import AccuracyUtilities as AU

#check http://stackoverflow.com/questions/2827623/python-create-object-and-add-attributes-to-it
class Object(object):
    pass

class readDataThread(QtCore.QThread):
    def __init__(self,  dataFile,detectFile, removeNoiseFlag,SignalStart, SignalEnd, \
		 selectedFeatureExtractionMethod,selectedPreprocessingMethod,FeatureEnhancementSelectedMethod, classifierSelected, \
		 trainTestFlag = True, selectedData=None, sameFile = True, verbose = False):
        QtCore.QThread.__init__(self)
        self.path = dataFile
	self.sameFile = sameFile
        #write any initialization here
        self.dataFile = str(dataFile)
	self.detectFile = str(detectFile)

	if (self.detectFile == None):
	    if (self.sameFile):
		self.detectFile = self.path
	    else:
		#detectFile is None while samefile is False !
		print "detectFile is set to None while we're detecting from another file!"

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
	self.verbose = verbose
	

    def run(self): 
	#"../Osama Mohamed.csv",1,1,0,0,0,0,0,0,1,0,0,0,4
	
	#TrainOut = KNN_Generic(directory, noiseFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,CSPFlag,startD,endD)

	#TODO: change f*FLag to f*Flag!
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
	    if (self.detectFile != None):
		self.detectData()
	    else:
		print "Detection failed cause of a missing detection file!"
    
    def getIndexFromTo(self):
	selD = self.selectedData;
	trialnum = int(self.dataLength)
	window = 0.2 * trialnum

	index = Object()
	if (self.sameFile == True):
	    if(selD["All"] == True):
		start = 0
		end = trialnum
		
	    elif(selD["off0"] == True):
		start = 0
		end = window
	    elif(selD["off1"] == True):
		start = 0.2 * trialnum
		end = start + window
	    elif(selD["off2"] == True):
		start = 0.4 * trialnum
		end = start + window
	    elif(selD["off3"] == True):
		start = 0.6 * trialnum
		end = start + window
	    elif(selD["off4"] == True):
		start = 0.8 * trialnum
		end = trialnum #forced in case we have a missing final trial
	    else:
		#that could be implemented as an exception: check
		#and we could even make an asserting function to detect any unexpected behavior
		print "ops, offset checkbox isn't selected for detection from the samefile"
		start = -1
		end = -1
	else:
	    #take the whole file in case its a new one
	    start = 0
	    end = trialnum

	index.start = int(start)
	index.end = int(end)

	return index
    
    def detectData(self):
	cf = self.classifierFile
	self.setPreProjectedFlag()

	self.classifierResult = []
	self.realClasses = []

	if (self.sameFile):
	    #print a convenient detection path to avoid the user getting confused
	    #if he has a selection of a different path even while selecting the sameFile checkbox
	    convDetectPath = self.path
	else:
	    convDetectPath = self.detectFile

	#we may be later interested in providing a feedback for the signal start and end too! but for now, that's definitely not!
	detectionDescription = "Train = " + self.path + "\r\nNoise Removal = " + str(self.removeNoiseFlag)+ "\r\nSame File" + str(self.sameFile) + "\r\nDetect" + convDetectPath + \
	"\r\nExtraction Flags = " + str(self.f1FLag) + str(self.f2FLag) + str(self.f3FLag) + str(self.f4FLag) + str(self.f5FLag) + str(self.f6FLag) + \
	"\r\nPreprocessing only method 1 for now\r\nEnhancement flags " + str(self.LDAFlag) + str(self.PCAFlag) + str(self.CSP_LDAFlag) + str(self.CSPFlag) + "\r\nClassifier " + cf

	indexWindow = 0

	if (cf == "KNN"):
	    trials = self.captureTrialData()
	    index = trials["index"]
	    indexWindow = index.end - index.start
	    self.knnResultInput["TrainOut"] =  self.knnTrainOut

	    for i in range (indexWindow):

		if (self.sameFile == True):
		    trial = trials["trials"][i]
		elif (self.sameFile == False):
		    trial = trials["trials"][:,:,i]

		self.knnResultInput["TrialData"] = trial
		self.knnResult = self.octave.call('KNN_Generic_Detect.m',self.knnResultInput,  self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag, self.preProjectedFlag)
		if (self.verbose):
		    feedback = "trial " + str(i) + ": PCA " + str(self.knnResult.PCAresult) + ", LDA " + str(self.knnResult.LDAresult)
		    print "test"
		    print self.knnResult.voteLDA
		    print str(self.knnResult.Ktargets)
		    print feedback

		if (self.PCAFlag == 1):
		    self.classifierResult.append(self.knnResult.PCAResultClass)
		elif (self.LDAFlag == 1):
		    self.classifierResult.append(self.knnResult.LDAResultClass)

		self.realClasses = self.knnTrainOut.ClassesTypes


	elif (cf == "Fisher"):
	    trials = self.captureTrialData()
	    index = trials["index"]
	    indexWindow = index.end - index.start
	    self.fisherResultInput["TrainOut"] =  self.fisherTrainOut

	    for i in range (indexWindow):

		if (self.sameFile == True):
		    # this condition implies wer had a preprocessed data ie: 1x28 trials
		    trial = trials["trials"][i]
		elif (self.sameFile == False):
		    # this conditio implies we had a raw data ie: 14x512 channelsXsamples
		    trial = trials["trials"][:,:,i]
		
		self.fisherResultInput["TrialData"] = trial
		self.fisherResult = self.octave.call('Fisher_Generic_Detect.m',self.fisherResultInput,  self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag, self.preProjectedFlag)
		if (self.verbose):
		    feedback = "trial " + str(i) + ": PCA " + str(self.fisherResult.PCAresult) + ", LDA " + str(self.fisherResult.LDAresult)
		    print feedback

		#TODO move into a separate function
		if (self.PCAFlag == 1):
		    self.classifierResult.append(self.fisherResult.PCAResultClass)
		elif (self.LDAFlag == 1):
		    self.classifierResult.append(self.fisherResult.LDAResultClass)

		self.realClasses = self.fisherTrainOut.ClassesTypes

	elif (cf == "Likelihood"):
	    trials = self.captureTrialData()
	    index = trials["index"]
	    indexWindow = index.end - index.start
	    self.likelihoodResultInput["TrainOut"] =  self.likelihoodTrainOut

	    for i in range (indexWindow):

		if (self.sameFile == True):
		    trial = trials["trials"][i]
		elif (self.sameFile == False):
		    trial = trials["trials"][:,:,i]

		self.likelihoodResultInput["TrialData"] = trial
		self.likelihoodResult = self.octave.call('Likelihood_Generic_Detect.m',self.likelihoodResultInput,  self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag, self.preProjectedFlag)
		if (self.verbose):
		    feedback = "trial " + str(i) + ": PCA " + str(self.likelihoodResult.PCAresult) + ", LDA " + str(self.likelihoodResult.LDAresult)
		    print feedback

		if (self.PCAFlag == 1):
		    self.classifierResult.append(self.likelihoodResult.PCAResultClass)
		elif (self.LDAFlag == 1):
		    self.classifierResult.append(self.likelihoodResult.LDAResultClass)

		self.realClasses = self.likelihoodTrainOut.ClassesTypes

	elif (cf == "Least Squares"):
	    trials = self.captureTrialData()
	    index = trials["index"]
	    indexWindow = index.end - index.start
	    self.leastSquaresResultInput["TrainOut"] =  self.leastSquaresTrainOut

	    for i in range (indexWindow):

		if (self.sameFile == True):
		    trial = trials["trials"][i]
		elif (self.sameFile == False):
		    trial = trials["trials"][:,:,i]

		self.leastSquaresResultInput["TrialData"] = trial
		self.leastSquaresResult = self.octave.call('Leastsquares_Generic_Detect.m',self.leastSquaresResultInput,  self.dataFile, self.removeNoiseFlag, self.f1FLag,self.f2FLag,self.f3FLag,self.f4FLag,self.f5FLag,self.f6FLag,self.LDAFlag,self.PCAFlag,self.CSP_LDAFlag,self.CSPFlag, self.preProjectedFlag)
		if (self.verbose):
		    feedback = "trial " + str(i) + ": PCA " + str(self.leastSquaresResult.PCAresult) + ", LDA " + str(self.leastSquaresResult.LDAresult)
		    print feedback

		if (self.PCAFlag == 1):
		    self.classifierResult.append(self.leastSquaresResult.PCAResultClass)
		elif (self.LDAFlag == 1):
		    self.classifierResult.append(self.leastSquaresResult.LDAResultClass)

		self.realClasses = self.leastSquaresTrainOut.ClassesTypes


	self.trialStatues(indexWindow)
	if (self.verbose):
	    print self.comparisonResults
	accTest = AU()
	accTestResult = accTest.correctPercentAccuracy(self.comparisonResults, self.verbose)
	summary = detectionDescription + "\r\n" + str(accTestResult) + "\r\n"
	print summary

    #for all the trials, compare and get the results into comparisonResults
    def trialStatues(self, indexWindow):

	self.comparisonResults = []

	for i in range (indexWindow):
	    if (self.classifierResult[i] == int(self.realClasses[i])):

		self.comparisonResults.append(True)

	    else:

		self.comparisonResults.append(False)
	
	return self.comparisonResults

    def  captureTrialData(self):

	trials = {}
	if (self.sameFile == 1): 
	    index = self.getIndexFromTo()
	    if(self.LDAFlag == 1):

		## use the following to test the dimensions we get for each trial!
		## our first ref was 20x28
		#temp = self.LDAData[index.start:index.end]
		#print temp.shape
		trials["trials"] = self.LDAData[index.start:index.end]
		trials["index"] = index

	    elif(self.PCAFlag == 1):

		#notice that giving an upper index higher than the available no of elements, would clamp to the the number of elements
		trials["trials"] = self.PCAData[index.start:index.end]
		trials["index"] = index

	    return trials

	elif (self.sameFile == 0):
	    #read data from self.detectFile
	    #set trialnum
	    #TODO change 0 and 4 to the sampleStart and sampleEnd
	    octTrials = self.octave.call('getTrialsData.m', self.detectFile, 0, 4)

	    self.dataLength = int(octTrials.shape[2])
	    #another way would be by adding a size attr to octTrials from getTrialsData.m ie:
	    #self.dataLength = int(octTrials)

	    # for debugging purposes use the following line ^_^
	    #print octTrials[:,:,3].shape

	    trials["trials"] = octTrials #the trials data itself need to call getMuBeta functions
	    trials["index"] = self.getIndexFromTo()

	    return trials

    def setPreProjectedFlag(self):
	if (self.sameFile):
	    self.preProjectedFlag = 1
	else:
	    self.preProjectedFlag = 0