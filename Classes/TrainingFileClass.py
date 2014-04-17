class TrainingFileClass(object):
    @staticmethod
    def getName(filepath):
        logfile = open(filepath, "r").readlines()
        
        for line in logfile:
            words = line.split(':')
            if(words[0] == "Name"):
                return words[1].strip()

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