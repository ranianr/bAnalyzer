import os
#import AppConfig as AC

class ThreadsDebugUtilities():

    #TODO: avoid breaking upon errors of open/write
    #print trainout to a new file, in debug directory, for now print it in the main directory
    @staticmethod
    def printFileTrainOut(trainOut, description, detectionFileName, sessionName="unknown"):
        # prepare directory (unique for each session)
        fpath = os.getcwd() + "/Debug/" + sessionName
        if not os.path.exists(fpath): os.makedirs(fpath)

        # prepare fname (unique for the detection method/user), remove the .csv too
        fname = fpath + "/" + description + os.path.splitext(detectionFileName)[0]
        
        # use to avoid overwriting
        # TODO: check it's better to overwrite or not
        isFileFlag = os.path.isfile(fname)

        # create file
        if (isFileFlag == False):
            f = open(fname, 'w')
            print f

        # avoid overwriting files!
        elif (isFileFlag == True):
            i = 0

            newfname = fname + str(i)
            while ((os.path.isfile(newfname)) & (i < 1000)):
                i = i + 1
                newfname = fname + str(i)
            if (i >= 1000):
                print "too many (1000) files were made for the same training file/session"

            f = open(newfname, 'w')

        # write to file
        f.write(description + "\r\n" + str(trainOut))
        print "\r\nWritten trainOut into the file: " + f.name + "\r\n ==========\r\n"
