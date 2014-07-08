class TrainingFileClass(object):
    @staticmethod
    def getName(filepath):
        logfile = open(filepath, "r").readlines()
        
        for line in logfile:
            words = line.split(':')
            if(words[0] == "Name"):
                return words[1].strip()
   
    @staticmethod
    def getDescription(filepath):
        logfile = open(filepath, "r").readlines()
        
        for line in logfile:
            words = line.split(':')
            if(words[0] == "Comments"):
                return words[1].strip()

    @staticmethod
    def getSession(filepath):
        logfile = open(filepath, "r").readlines()
        
        for line in logfile:
            words = line.split(':')
            if(words[0] == "Source"):
                # Detection session
                parts = words[1].strip().split('/')
                return parts[0]
            if(words[0] == "Session"):
                # Training session
                return words[1].strip()

    #TODO: unhack isTrain and isDetect by searching for the Training/Detection keyword
    @staticmethod
    def isTrain(filepath):
        logfile = open(filepath, "r").readlines()
        
        for line in logfile:
            words = line.split(':')
            if(words[0] == "Session"):
                return True

        return False

    @staticmethod
    def isDetect(filepath):
        logfile = open(filepath, "r").readlines()
        
        for line in logfile:
            words = line.split(':')
            if(words[0] == "Source"):
                return True

        return False

    @staticmethod
    def getClasses(filepath):
        logfile = open(filepath, "r").readlines()
        
        ClassList = {}
        
        for line in logfile:
            words = line.split(':')
            if(words[0] == "ClassesNames"):
                
                for i, className in enumerate(words[1].split(',')):
                    ClassList[className.strip()] = i
                
                return ClassList
