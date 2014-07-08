import os

class RecursiveImporterUtilities(object):

    @staticmethod
    def getDirCSVFiles(directory, verbose=True):

        csvFileList = []

        if (verbose):
            print "\r\nGetting CSV files\r\n-----------"

        #note: directory is a QString -> must be converted
        for root, dirs, fileNames in os.walk(str(directory)):
            for fileName in fileNames:
                fileBase, fileExt = os.path.splitext(fileName)
                if (fileExt == ".csv"):
                    fullPath = os.path.join(root, fileName)
                    csvFileList.append(fullPath)

                    if (verbose == True):
                        print "CSV File Search Found: " + fullPath

        if ((verbose == True) & (csvFileList == [])):
            print "CSV File Search Found: no files"
            print "\r\n"

        return csvFileList
