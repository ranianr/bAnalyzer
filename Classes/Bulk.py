import os
from threads import readDataThread

import gspread
import GooglespreadSheetConfig as GSC
from TrainingFileClass import TrainingFileClass as TFC
from GSpreadPrinting import GSpreadPrintingUtilities as GSPU


class BulkUtilities():

    @staticmethod
    def MultiFileBulkDetect(filesDict, noiseDict, featDict, preprocDict, enhanceDict, classDict, \
                   sampleStart, sampleEnd, selectedData, sameFile, updateGSpread=False):

        k = 0
        threadList = []
        detectFileRowIndexDict = {}
        detectFileAccListDict = {}

        if (updateGSpread == True):
            ##Connect to google spreadsheet 
            gc = gspread.login(GSC.email, GSC.password)
            sh = gc.open(GSC.title) 
            worksheet = sh.worksheet(GSC.sheet_title)

        print "\r\nDebug"
        print "------"
        print filesDict
        print filesDict.items()
        print "\r\n"

        for tfItem, tfValue in filesDict.items():
            ## given a train file, and dict methods, detect files, loop on each and do magic!

            print "Training File: " + tfItem
            print "************"

            # reset to the first column
            i = 0

            tfDesc = TFC.getDescription(tfItem)
            tfName = TFC.getName(tfItem)

            if (updateGSpread == True):
                rowIndex = GSPU.getEmptyRowIndex(range(1, 10))
                j = 0
                worksheet.update_cell(rowIndex, 3, tfDesc)
                worksheet.update_cell(rowIndex, 2, tfName)
            
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
                                # TODO: when we support separate training from the detection, do the training here and detect for each file by itself
                                # that would speed the process too much if we've multiple detection sessions for the same training session

                                if (BulkUtilities.CheckTrainingFile(tfItem, tfValue, False) == False):
                                    continue
                                
                                #df are stored as lists
                                for dfItem in tfValue:
                                    print "Detection File: " + dfItem
                                    print "************"

                                    # use rowIndex
                                    if (updateGSpread == True):
                                        if dfItem + tfItem in detectFileRowIndexDict:
                                            # a recurrent detection file
                                            print "---- test ----"
                                            print "---- recurrent ----"
                                            print dfItem
                                            print tfItem
                                            print rowIndex
                                            print "---- test ----"
                                            rowIndex = detectFileRowIndexDict[dfItem + tfItem]
                                        else:
                                            # a new detection file ^_^
                                            rowIndex = GSPU.getEmptyRowIndex(range(1, 10))
                                            detectFileRowIndexDict[dfItem + tfItem] = rowIndex

                                            dfDesc = TFC.getDescription(dfItem)
                                            dfName = TFC.getName(dfItem)

                                            worksheet.update_cell(rowIndex, 8, dfDesc)
                                            worksheet.update_cell(rowIndex, 7, dfName)
            
                                            print "---- test ----"
                                            print "---- first timer ----"
                                            print dfItem
                                            print tfItem
                                            print rowIndex
                                            print "---- test ----"

                                    Path = "Path " + str(i) + ": " + noiseItem + ", " + featItem + ", " + preprocItem + ", " + enhanceItem + ", " + classItem
                                    print Path
                                    print classItem
                                    print classValue

                                    #note the program behaves strangely when threads aren't closed :|
                                    # how: for changing second value ->> readDataThread won't "always" recieve the right dfItem, but rather a cached copy of it
                                    # may be the reason we didn't wait for the thread after getAcc!
                                    thread = readDataThread(tfItem, dfItem, wrappingNoiseValue, sampleStart, sampleEnd, \
                                                            featValue, preprocValue, enhanceValue, classValue, \
                                                            False, selectedData, sameFile, True)
                                    thread.start()
                                    thread.wait()

                                    if (updateGSpread == True):
                                        Acc = thread.getAcc()
                                        thread.wait()

                                        if dfItem + tfItem in detectFileAccListDict:
                                            detectFileAccListDict[dfItem + tfItem].append(Acc)
                                        else:
                                            detectFileAccListDict[dfItem + tfItem] = []
                                            detectFileAccListDict[dfItem + tfItem].append(Acc)

                                        #Write the path description and it's accuracy 
                                        worksheet.update_cell(rowIndex + 1, 9 + j , Path)
                                        worksheet.update_cell(rowIndex + 1, 10 + j , Acc)

                                        #Array to hold accurcies of all paths
                                        #accumelatedAcc.append(Acc)

                                    thread.exit()

                                if (updateGSpread):
                                    # move to the next 2 columns once finished all the detection files
                                    j += 2


                                # get into the next column
                                i += 1

            # for each Training File
            if ((updateGSpread == True) & (i > 0)):
                #Get the Min, Max and avrg accuracy then write them
                for tfItem, tfValue in filesDict.items():
                    for dfItem in tfValue:
                        accumelatedAcc = detectFileAccListDict[dfItem + tfItem]
                        rowIndex = detectFileRowIndexDict[dfItem + tfItem]
        
                        mySorted = sorted(accumelatedAcc)
                        worksheet.update_cell(rowIndex, 4 , mySorted[0])
                        print "i is " + str(i)
                        print mySorted
                        print detectFileAccListDict
                        print detectFileAccListDict.items
                        print "Rania is here"
                        
                        worksheet.update_cell(rowIndex, 5 , mySorted[i-1])
                        temp = 0
                        for k in range(0, i):
                            temp = temp + accumelatedAcc[k]
                        avrg = temp / len(accumelatedAcc)
                        worksheet.update_cell(rowIndex, 6 , avrg)

        print "-----------------------"
        print "Finished bulk detection"


    @staticmethod
    def GetDetectMatchTrain(trainFile, detectDir, verbose=True):
        trainFileSsn = TFC.getSession(trainFile)
        trainFileSubject = TFC.getName(trainFile)

        if(verbose == True):
            print "Matching Training file:"
            print "File: " + trainFile
            #print matching criterions
            print "-> Session: " + trainFileSsn
            print "-> Subject: " + trainFileSubject

        detFileList = []
        for root, dirs, detFileNames in os.walk(str(detectDir)):
            for fileName in detFileNames:
                fullDetFileName = os.path.join(root, fileName)

                detFileSsn = TFC.getSession(fullDetFileName)
                detFileSubject = TFC.getName(fullDetFileName)

                #check its a detection file to avoid matching training files in the same directory/subdirectories
                if((detFileSsn == trainFileSsn) & (detFileSubject == trainFileSubject) & (TFC.isDetect(fullDetFileName))):
                    # Check f is a name
                    detFileList.append(fullDetFileName)

                    if(verbose == True):
                        print "-> Matched detection file: " + fullDetFileName + "\r\n"

        if ((verbose == True) & (detFileList == [])):
            print "-> No matching detection file in the detection directory"
            print "-> Ensure we have consistent subject name/session in the training and detection files\r\n"

        return detFileList

    @staticmethod
    def CheckTrainingFile(trainFileName, detFileList, verbose=False):
        valid = True

        if(detFileList == []):
            valid = False
            if(verbose == True):
                print "Warning: training file: " + trainFileName + "\r\n\thas no detection file matches :<"

        elif(detFileList == None):
            if(verbose == True):
                print "Undetermined error with training/detection file(s) for " + trainFileName
            valid = False

        return valid

