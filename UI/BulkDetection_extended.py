import os
import thread
import gspread
from PyQt4 import QtCore, QtGui
from TrainingFileClass import TrainingFileClass
from multiprocessing.pool import ThreadPool

#select multiple buttons
#select all button for each bar
#deselect all fn for each bar

#make multiple calls to threads according the input of each and every time

from threads import readDataThread
from BulkDetection import Ui_BulkDetectionWindow
#from assertions import Ui_MainWindow_assertions
import AppConfig
import BulkDetectionConfig as BDConfig
import GooglespreadSheetConfig as GSC

from CrossValidation import CrossValidationUtilities as CVU
from GSpreadPrinting import GSpreadPrintingUtilities as GSPU
from Bulk import BulkUtilities as BU
from FileImporters import RecursiveImporterUtilities as RIU

class Ui_BulkDetectionWindow_Extended(Ui_BulkDetectionWindow):

    def __init__(self):
        Ui_BulkDetectionWindow.__init__(self)
        self.selectedData = {}

    def InitializeUI(self):
        self.SetGUIOptionsByAppConfig()

        QtCore.QObject.connect(self.allNoiseRB, QtCore.SIGNAL(("toggled(bool)")), self.NoiseRB_toggled) #Noise Radio button
        QtCore.QObject.connect(self.allFeaturesRB, QtCore.SIGNAL(("toggled(bool)")), self.FeaturesRB_toggled) #Features Radio button
        QtCore.QObject.connect(self.allPreprocessingRB, QtCore.SIGNAL(("toggled(bool)")), self.PreprocessingRB_toggled) #Preprocessing Radio button
        QtCore.QObject.connect(self.allEnhancementRB, QtCore.SIGNAL(("toggled(bool)")), self.EnhancementRB_toggled) #Enhancement Radio button
        QtCore.QObject.connect(self.allClassifiersRB, QtCore.SIGNAL(("toggled(bool)")), self.ClassifiersRB_toggled) #Classifiers Radio button
        QtCore.QObject.connect(self.BulkDetectBtnBox, QtCore.SIGNAL(("accepted()")), self.BulkDetectBtnBox_accepted) #Bulk Detect button
        #TODO: add signlas for the text boxes!
        QtCore.QObject.connect(self.trainDirBrowseB, QtCore.SIGNAL(("clicked()")), self.TrainDirB_Clicked) #Train button
        QtCore.QObject.connect(self.detectDirBrowseB, QtCore.SIGNAL(("clicked()")), self.DetectDirB_Clicked) #Detect button
        QtCore.QObject.connect(self.trainFileBrowseB, QtCore.SIGNAL(("clicked()")), self.TrainFileB_Clicked) #Train button
        QtCore.QObject.connect(self.detectFileBrowseB, QtCore.SIGNAL(("clicked()")), self.DetectFileB_Clicked) #Detect button

    #TODO: make the appconfig an object that could be changed itself, not just a static method
    #TODO: make other setters for the selfies and remove the whole setters thing to a new file ^_^!
    def SetGUIOptionsByAppConfig(self):

	#PS: we're overwriting both the internal values and GUI fields
	# train file path
        self.trainFilePath = AppConfig.TrainingFile
	#self.datafile.setText(self.trainFilePath)

        self.sampleStart = AppConfig.SampleStart
        self.sampleEnd = AppConfig.SampleEnd

	# detectFilePath
	if (AppConfig.SameFileFlag == False):
            self.detectFilePath = AppConfig.DetectionFile
	    #self.DetectDataFile.setText(self.detectFilePath)
	else:
	    self.detectFilePath = None
	    #self.DetectDataFile.setText("")

	# same file options
	self.sameFile = AppConfig.SameFileFlag
        self.selectedData["All"] = AppConfig.All
        self.selectedData["off0"] = AppConfig.Offset0
        self.selectedData["off1"] = AppConfig.Offset1
        self.selectedData["off2"] = AppConfig.Offset2
        self.selectedData["off3"] = AppConfig.Offset3
        self.selectedData["off4"] = AppConfig.Offset4

	#self.allData2080.setChecked(AppConfig.All)
	#self.offset_0_2080.setChecked(AppConfig.Offset0)
	#self.offset_1_2080.setChecked(AppConfig.Offset1)
	#self.offset_2_2080.setChecked(AppConfig.Offset2)
	#self.offset_3_2080.setChecked(AppConfig.Offset3)
	#self.offset_4_2080.setChecked(AppConfig.Offset4)

        self.allNoiseRB.setChecked(BDConfig.NoiseRemovalAll)
        self.noiseRemCB.setChecked(BDConfig.NoiseRemoval & BDConfig._Remove)
        self.noiseRemRawCB.setChecked(BDConfig.NoiseRemoval & BDConfig._Raw)

        self.allFeaturesRB.setChecked(BDConfig.FeaturesAll)
        self.meanCB.setChecked(BDConfig.FeaturesMethod & BDConfig._Mean)
        self.lMhBCB.setChecked(BDConfig.FeaturesMethod & BDConfig._LMhB)
        self.lMhBmCB.setChecked(BDConfig.FeaturesMethod & BDConfig._LMhBm)
        self.lMBhMBCB.setChecked(BDConfig.FeaturesMethod & BDConfig._LMBhMB)
        self.lMBhMBmCB.setChecked(BDConfig.FeaturesMethod & BDConfig._LMBhMBm)

        self.allPreprocessingRB.setChecked(BDConfig.PreprocessingAll)
        self.butterCB.setChecked(BDConfig.PreprocessingMethod & BDConfig._Butter)
        self.idealCB.setChecked(BDConfig.PreprocessingMethod & BDConfig._Ideal)

        self.allEnhancementRB.setChecked(BDConfig.EnhancementAll)
        self.PCACB.setChecked(BDConfig.EnhancementMethod & BDConfig._PCA)
        self.LDACB.setChecked(BDConfig.EnhancementMethod & BDConfig._LDA)
        self.NoneCB.setChecked(BDConfig.EnhancementMethod & BDConfig._None)

        self.allClassifiersRB.setChecked(BDConfig.ClassificationAll)
        self.fisherCB.setChecked(BDConfig.ClassificationMethod & BDConfig._Fisher)
        self.KNNCB.setChecked(BDConfig.ClassificationMethod & BDConfig._KNN)
        self.likelihoodCB.setChecked(BDConfig.ClassificationMethod & BDConfig._Likelihood)
        self.leastSquaresCB.setChecked(BDConfig.ClassificationMethod & BDConfig._LeastSquares)

        self.trainPath = BDConfig.TrainPath
        self.trainPathT.setText(self.trainPath)
        self.detectPath = BDConfig.DetectPath
        self.detectPathT.setText(self.detectPath)

        self.updateGDocsCB.setChecked(BDConfig.UpdateGDocs)

    ######## signaling functions #######
    def NoiseRB_toggled(self, value):
        self.NoiseCBSetter(value)

    def FeaturesRB_toggled(self, value):
        self.FeaturesCBSetter(value)

    def PreprocessingRB_toggled(self, value):
        self.PreprocessingCBSetter(value)

    def EnhancementRB_toggled(self, value):
        self.EnhancementCBSetter(value)

    def ClassifiersRB_toggled(self, value):
        self.ClassifiersCBSetter(value)

    def BulkDetectBtnBox_accepted(self):
        # for all the Class. with all the enhancement, using all the preprocessing methods for each feature!
        print self.trainPathT.toPlainText()
        print self.detectPathT.toPlainText()
        self.trainPath = self.trainPathT.toPlainText()
        self.detectPath = self.detectPathT.toPlainText()

        self.BulkDetectExec()

    def TrainDirB_Clicked(self):
        self.fileDialog = QtGui.QFileDialog()
        self.trainPath = self.getDirName()

        self.trainPathT.setText(self.trainPath)

    def DetectDirB_Clicked(self):
        self.fileDialog = QtGui.QFileDialog()
        self.detectPath = self.getDirName()

        self.detectPathT.setText(self.detectPath)

    def TrainFileB_Clicked(self):
        self.fileDialog = QtGui.QFileDialog()
        self.trainPath = self.getFileName()

        self.trainPathT.setText(self.trainPath)

    def DetectFileB_Clicked(self):
        self.fileDialog = QtGui.QFileDialog()
        self.detectPath = self.getFileName()

        self.detectPathT.setText(self.detectPath)

    ######## end of signaling functions ######
    
	
    ######## Bulk
    def BulkDetectExec(self):
        #TODO: add assertions -> there must be at least a single selected checkbox for each column
        #TODO: add time estimation, even static ones would be great for now! calc a trial p

        verbose = True

        noiseDict = self.DictOfNoiseCB()
        featDict = self.DictOfFeaturesCB()
        preprocDict = self.DictOfPreprocessingCB()
        enhanceDict = self.DictOfEnhancementCB()
        classDict = self.DictOfClassifiersCB()

        filesDict = self.DictOfFiles(self.trainPath, self.detectPath, verbose)
        updateGDocs = self.CBGetter(self.updateGDocsCB)

        trainPath = self.trainPath
        detectPath = self.detectPath

        #Check the logic out
        if (self.sameFile):
            print "samefile is set, entering 80/20!"
            CVU.BulkEightyTweenty(filesDict, noiseDict, featDict, preprocDict, enhanceDict, classDict, \
                                self.sampleStart, self.sampleEnd, self.sameFile, updateGDocs)

        else:
            print "samefile is not set, entering BulkDetect!"
        
            #separate the multiple files mode from the single file one
            CDR = self.CheckDir(trainPath, detectPath, verbose)

            if (CDR.isDirectory):
                BU.MultiFileBulkDetect(filesDict, noiseDict, featDict, preprocDict, enhanceDict, classDict, \
                                       self.sampleStart, self.sampleEnd, self.selectedData, self.sameFile, updateGDocs)
            elif (CDR.isFile):
                self.SingleFileBulkDetect()
            else:
                print "Warning: supplied path isn't valid"

    def SingleFileBulkDetect(self):
        #TODO: add assertions -> there must be at least a single selected checkbox for each column
        #TODO: add time estimation, even static ones would be great for now! calc a trial p
        noiseDict = self.DictOfNoiseCB()
        featDict = self.DictOfFeaturesCB()
        preprocDict = self.DictOfPreprocessingCB()
        enhanceDict = self.DictOfEnhancementCB()
        classDict = self.DictOfClassifiersCB()
	
	##Connect to google spreadsheet 
	gc = gspread.login( GSC.email , GSC.password)
	sh = gc.open(GSC.title)
	worksheet = sh.worksheet(GSC.sheet_title)
	self.rowIndex = GSPU.getEmptyRowIndex(range(1, 10))

        self.threadList = []
        i = 0
	j = 0
	print "Traing File: " + self.trainPath
	print "************"

	print "Detection File: " + self.detectPath
	print "************"
	
	desc = TrainingFileClass.getDescription(self.trainPath)
	name = TrainingFileClass.getName(self.trainPath)
	
	worksheet.update_cell(self.rowIndex, 3, desc)
	worksheet.update_cell(self.rowIndex, 2, name)
	
	self.accumelatedAcc = []
        print "Creating Detection Paths:"
        print "-------------------------"

        for noiseItem,noiseValue in noiseDict.items():
	    #TODO: remove this hack! a hack till we propagate the noise removal to be an unified variable(enum or struct) throughout all the code!
	    wrappingNoiseValue = False
	    if (noiseItem == "Remove") & (noiseValue & True):
		wrappingNoiseValue = True
	    elif (noiseItem == "Raw") & (noiseValue & True):
		wrappingNoiseValue = False

            for preprocItem, preprocValue in preprocDict.items():
		#get feature dictionary 
		for featItem, featValue in featDict.items():
                    for enhanceItem, enhanceValue in enhanceDict.items():
                        for classItem, classValue in classDict.items():

                            Path = "Path " + str(i) + ": " +noiseItem + ", " + featItem + ", " + preprocItem + ", " + enhanceItem + ", " + classItem
			    print Path
			    print classValue
                            thread = readDataThread(self.trainPath, self.detectPath, wrappingNoiseValue, self.sampleStart, self.sampleEnd, \
                                                    featValue, preprocValue, enhanceValue, classValue, \
						    False, self.selectedData, self.sameFile,True)
                            self.threadList.append(thread)
                            self.threadList[i].start()
                            self.threadList[i].wait()
			    Acc = self.threadList[i].getAcc()
			    #Write the path description and it's accuracy 
			    worksheet.update_cell(self.rowIndex, 7+j , Path)
			    worksheet.update_cell(self.rowIndex, 8+j , Acc)

			    #Array to hold accurcies of all paths
			    self.accumelatedAcc.append(Acc)
			    
                            i += 1
			    j += 2
			    
	#Get the Min, Max and avrg accuracy then write them 
	self.sorted = sorted(self.accumelatedAcc)
	worksheet.update_cell(self.rowIndex, 4 , self.sorted[0])
	worksheet.update_cell(self.rowIndex, 5 , self.sorted[i-1])
	temp = 0
	for o in range(0, i):
	    temp = temp + self.accumelatedAcc[o]
	avrg = temp / len(self.accumelatedAcc)
	worksheet.update_cell(self.rowIndex, 6 , avrg)
	
        print "-----------------------"
        print "Finished bulk detection"

    ######## helping functions #########
    
    def DictOfNoiseCB(self):
        noiseDict = {}
	if(self.CBGetter(self.noiseRemCB)):
            noiseDict["Remove"] = True
	if(self.CBGetter(self.noiseRemRawCB)):
            noiseDict["Raw"] = True
        return noiseDict

    #TODO: change the binding into global enum
    def DictOfFeaturesCB(self):
	if(self.CBGetter(self.butterCB)):
	    featDict = {}
	    if(self.CBGetter(self.meanCB)):
		featDict["mean"] = "mean"
	    if(self.CBGetter(self.lMhBCB)):
		featDict["lMhB"] = "Min MU and Max Beta"
	    if(self.CBGetter(self.lMhBmCB)):
		featDict["lMhBm"] = "Min Mu, Max Beta, Mean Mu, Mean Beta"
	    if(self.CBGetter(self.lMBhMBCB)):
		featDict["lMBhMB"] = "Min Mu Max Mu Min Beta Max Beta"
	    if(self.CBGetter(self.lMBhMBmCB)):
		featDict["lMBhMBm"] = "Min Mu, max Mu, Min Beta, Max Beta, Mean Mu, Mean Beta"
	    return featDict
	
	elif(self.CBGetter(self.idealCB)):
	    featDict = {}
	    if(self.CBGetter(self.meanCB)):
		featDict["mean"] = "mean"
	    if(self.CBGetter(self.lMhBCB)):
		featDict["min"] = "min"
	    if(self.CBGetter(self.lMhBmCB)):
		featDict["max"] = "max"
	    return featDict

    def DictOfPreprocessingCB(self):
        preprocDict = {}
        if(self.CBGetter(self.butterCB)):
            preprocDict["butter"] = "butter"
	if(self.CBGetter(self.idealCB)):
            preprocDict["ideal"] = "ideal"
        return preprocDict

    def DictOfEnhancementCB(self):
        EnhanceDict = {}
        if(self.CBGetter(self.PCACB)):
            EnhanceDict["PCA"] = "PCA"
        if(self.CBGetter(self.LDACB)):
            EnhanceDict["LDA"] = "LDA"
	if(self.CBGetter(self.NoneCB)):
            EnhanceDict["None"] = "None"
        return EnhanceDict

    def DictOfClassifiersCB(self):
        ClassDict = {}
        if(self.CBGetter(self.fisherCB)):
            ClassDict["fisher"] = "Fisher"
        if(self.CBGetter(self.KNNCB)):
            ClassDict["KNN"] = "KNN"
        if(self.CBGetter(self.likelihoodCB)):
            ClassDict["likelihood"] = "Likelihood"
        if(self.CBGetter(self.leastSquaresCB)):
            ClassDict["leastSquares"] = "Least Squares"
        return ClassDict

    # TODO: change to a static method!
    def DictOfFiles(self, trainPath, detectPath, verbose=True):
        # Get train files list
        filesDict = {}
        print self.sameFile

        if (verbose):
            print "\r\nCreating file dictionaries:\r\n------------------"
            print "Dict of files contains the following entry/entries"

        if (self.sameFile):
            train_filename = self.trainPath
            detect_filename = detectPath
            filesDict[train_filename] = detect_filename

            if (verbose):
                print train_filename
                print detect_filename

        #TODO: remove duplicate code, unify the behavior
        else:
            #separate the multiple files mode from the single file one
            CDR = self.CheckDir(trainPath, detectPath, verbose)
            if (CDR.isDirectory):
                #get train files list
                trainFiles = RIU.getDirCSVFiles(trainPath)
    
                for tf in trainFiles:
                    detectFiles = BU.GetDetectMatchTrain(tf, detectPath)
                    filesDict[tf] = detectFiles

                    if (verbose):
                        print tf
                        print detectFiles

            elif (CDR.isFile):
                train_filename = trainPath
                detect_filename = detectPath
                filesDict[train_filename] = detect_filename

                if (verbose):
                    print train_filename
                    print detect_filename

            else:
                print "Couldn't retrieve the file dictionary\r\n"

        if (verbose):
            print "\r\n"

        return filesDict

    def NoiseCBSetter(self, value):
        self.CBSetter(self.noiseRemCB, value)
        self.CBSetter(self.noiseRemRawCB, value)

    def FeaturesCBSetter(self, value):
        self.CBSetter(self.meanCB, value)
        self.CBSetter(self.lMhBCB, value)
        self.CBSetter(self.lMhBmCB, value)
        self.CBSetter(self.lMBhMBCB, value)
        self.CBSetter(self.lMBhMBmCB, value)

    def PreprocessingCBSetter(self, value):
        self.CBSetter(self.butterCB, value)
	self.CBSetter(self.idealCB, value)

    def EnhancementCBSetter(self, value):
        self.CBSetter(self.PCACB, value)
        self.CBSetter(self.LDACB, value)
        self.CBSetter(self.NoneCB, value)
    
    def ClassifiersCBSetter(self, value):
        self.CBSetter(self.fisherCB, value)
        self.CBSetter(self.KNNCB, value)
        self.CBSetter(self.likelihoodCB, value)
        self.CBSetter(self.leastSquaresCB, value)

    #generic Checkbox setter
    def CBSetter(self, checkBox, value=True):
        checkBox.setChecked(value)

    #generic Checkbox getter
    def CBGetter(self, checkBox):
        return checkBox.isChecked()

    def getDirName(self):
        return self.fileDialog.getExistingDirectory()

    def getFileName(self):
        return self.fileDialog.getOpenFileName()

    @staticmethod
    def CheckDir(trainPath, detectPath, verbose=False):
        CDR = CheckDirReturn()

        if (os.path.isdir(trainPath)):
            if (os.path.isdir(detectPath)):
                CDR.isDirectory = True
            elif (os.path.isfile(detectPath)):
                CDR.isMixed = True
            else:
                CDR.inValid = True

        elif (os.path.isfile(trainPath)):
            if (os.path.isdir(detectPath)):
                CDR.isMixed = True
            elif (os.path.isfile(detectPath)):
                CDR.isFile = True
            else:
                CDR.inValid = True


        else:
            CDR.inValid = True

        if (verbose):
            print "Given train file is: " + str(trainPath)
            print "Given detect file is: " + str(detectPath)
            if (os.path.isfile(detectPath)):
                print "Detection path is a file"
            elif (os.path.isdir(detectPath)):
                print "Detection path is a directory"
            else:
                print "Detection path is invalid"

            if (os.path.isfile(trainPath)):
                print "Training path is a file"
            elif (os.path.isdir(trainPath)):
                print "Training path is a directory"
            else:
                print "Training path is invalid"

        return CDR

    ######## end of helping functions #########
class CheckDirReturn:
    isDirectory = False
    isFile = False
    isMixed = False
    inValid = False
