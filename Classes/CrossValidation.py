import os
from TrainingFileClass import TrainingFileClass
from threads import readDataThread
import gspread
import GooglespreadSheetConfig as GSC
from GSpreadPrinting import GSpreadPrintingUtilities as GSPU

class CrossValidationUtilities():

    @staticmethod
    def BulkEightyTweenty(filesDict, noiseDict, featDict, preprocDict, enhanceDict, classDict, \
                          sampleStart, sampleEnd, selectedData, updateGSpread=False):

        threadList = []
        offsetDict = {}

        #TODO: change to enums
        offsetDict["All"] = False
        offsetDict["off0"] = False
        offsetDict["off1"] = False
        offsetDict["off2"] = False
        offsetDict["off3"] = False
        offsetDict["off4"] = False

        if (updateGSpread == True):
            ##Connect to google spreadsheet 
            gc = gspread.login( GSC.email , GSC.password)
            sh = gc.open(GSC.title) 
            worksheet = sh.worksheet(GSC.sheet_title)

        for offsetItem, offsetValue in offsetDict.items():
            print "Detection Offset: " + str(offsetItem)
            print "************"

            i = 0

            if (updateGSpread == True):
                rowIndex = GSPU.getEmptyRowIndex(range(1, 10))
            
            for tfItem, tfValue in filesDict.items():
                ## given a train file, and dict methods, detect files, loop on each and do magic!
    
                print "Training File: " + tfItem
                print "************"
    
                desc = str(TrainingFileClass.getDescription(tfItem)) + " " + str(offsetItem)
                name = TrainingFileClass.getName(tfItem)
    
                if (updateGSpread == True):
                    j = 0
                    worksheet.update_cell(rowIndex, 3, desc)
                    worksheet.update_cell(rowIndex, 2, name)
                
                    accumelatedAcc = []
    
                print "Creating Detection Paths:"
                print "-----------------------"
    
                for noiseItem, noiseValue in noiseDict.items():
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
                                    # if we can separate the training from the detection, do the training here and detect for each file by itself
                                    # that would speed the process too much if we've multiple detection sessions for the same training session


                                    offsetDict = CrossValidationUtilities.SelectSingleDataOffset(offsetDict, offsetItem)

                                    Path = "Path " + str(i) + ": " + noiseItem + ", " + featItem + ", " + preprocItem + ", " + enhanceItem + ", " + classItem + ", " + str(offsetItem)
                                    print Path

                                    thread = readDataThread(tfItem, tfItem, wrappingNoiseValue, sampleStart, sampleEnd, \
                                                            featValue, preprocValue, enhanceValue, classValue, \
                                                            False, offsetDict, True, True)
                                    thread.start()
                                    thread.wait()

                                    if (updateGSpread == True):
                                        Acc = thread.getAcc()
                                        thread.wait()
                                        #Write the path description and it's accuracy 
                                        worksheet.update_cell(rowIndex, 7+j , Path)
                                        worksheet.update_cell(rowIndex, 8+j , Acc)

                                        #Array to hold accurcies of all paths
                                        accumelatedAcc.append(Acc)
                                        j += 2

                                    thread.exit()
                                    i += 1

        if ((updateGSpread == True) & (i > 0)):
            #Get the Min, Max and avrg accuracy then write them
            mySorted = sorted(accumelatedAcc)
            worksheet.update_cell(rowIndex, 4 , mySorted[0])
            worksheet.update_cell(rowIndex, 5 , mySorted[i-1])
            temp = 0
            for k in range(0, i):
                temp = temp + accumelatedAcc[k]
            avrg = temp / len(accumelatedAcc)
            worksheet.update_cell(rowIndex, 6 , avrg)

        print "-----------------------"
        print "Finished bulk detection"


    @staticmethod
    def DeselectDataOffset(offsetDict):
        for offsetItem, offsetValue in offsetDict.items():
            offsetDict[offsetItem] = False
        return offsetDict

    @staticmethod
    def SelectDataOffset(offsetDict, offsetName):
        offsetDict[offsetName] = True
        return offsetDict

    @staticmethod
    def SelectSingleDataOffset(offsetDict, offsetName):
        offsetDict = CrossValidationUtilities.DeselectDataOffset(offsetDict)
        offsetDict = CrossValidationUtilities.SelectDataOffset(offsetDict, offsetName)
        return offsetDict

    #is offsetDictNew useful?
    #is offsetDictNew needed?
    @staticmethod
    def SelectAllDataOffset(offsetDict):
        offsetDictNew = offsetDict
        for offsetName in offsetDict.items():
            offsetDictNew = CrossValidationUtilities.SelectDataOffset(offsetDictNew, offsetName)
        return offsetDictNew


#TODO: change naming to Offset_##
#class Offset(Enum):
#    All = 0
#    off0 = 1
#    off1 = 2
#    off2 = 3
#    off3 = 4
#    off4 = 5

