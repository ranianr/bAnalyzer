class Ui_MainWindow_assertions():

    #Some checks may be made upon the the text box entering ie: start-end check
    def preDetectCheck(self, trainFilePath, detectFilePath, removeNoiseFlag, sampleStart, sampleEnd,\
		     preprocessing, featureEnhancement, featureExtraction, classifier, \
		     sameFile, allData2080, offset_0_2080, offset_1_2080, offset_2_2080, offset_3_2080, offset_4_2080, \
		     printChecksFlag = True, printArgsFlag = False, localArgs = None):

	#initialization
	foundError = False
	unselectedTrainFileError = False
	unSelectedOffsetError = False
	unAvailableNewFileError = False
	unimplementedMethodError = False
	invalidStartENDError = False

	if (trainFilePath == None):
	    #we should check for path validity too! and may be the extension too
	    unselectedTrainFileError = True

	if (detectFilePath == None):
	    unAvailableNewFileError = True    

	if (sameFile == 1):
	    unSelectedOffsetError = (not(allData2080.isChecked() or offset_0_2080.isChecked() or offset_1_2080.isChecked() or offset_2_2080.isChecked() or offset_3_2080.isChecked() or offset_4_2080.isChecked()))
	    #revert this error in case we're detecting from the samefile already!
	    unAvailableNewFileError = False

	if (preprocessing == 1):
	    #we may check also for invalid selected methods!
	    unimplementedMethodError = True

	if ((sampleEnd <= sampleStart) or (sampleStart < 0)):
	    invalidStartENDError = True

	foundError = (unselectedTrainFileError or unSelectedOffsetError or unAvailableNewFileError or unimplementedMethodError or invalidStartENDError)

	if (printChecksFlag == True):
	    #invert the true for an error to be better user friendly!!
	    print "\r\n======Errors Check=====\r\n"
	    print "Train File = " + str(not(unselectedTrainFileError))
	    print "Selected Offset = " + str(not(unSelectedOffsetError))
	    print "Detect File = " + str(not(unAvailableNewFileError))
	    print "Selection of implemented methods = " + str(not(unimplementedMethodError))
	    print "Start/End valid = " + str(not(invalidStartENDError))
	    print "\r\n===========\r\n"

	if (printArgsFlag == True):
	    print "\r\n======Arguments Check=====\r\n"
	    print "Train file path = " + str(trainFilePath)
	    print "Detect file path = " + str(detectFilePath)
	    print "Remove noise flag = " + str(removeNoiseFlag)
	    print "Signal start = " + str(sampleStart)
	    print "Signal end = " + str(sampleEnd)
	    print "Feature extraction = " + str(featureExtraction)
	    print "Preprocessing = " + str(preprocessing)
	    print "Feature enhancement = " + str(featureEnhancement)
	    print "Classifier = " + str(classifier)
	    print "Same file = " + str(sameFile)

	    if (localArgs):

		for item, value in localArgs.items():
		    if (type(value) == dict):
			print item + " = " + str(value.items())
		    else:
			print item + " = " + str(value)

	    print "\r\n===========\r\n"

	return foundError
