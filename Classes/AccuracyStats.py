class AccuracyUtilities():
    def correctPercentAccuracy(self, comparisonArray):

        correctTrials = 0
        wrongTrials = 0

        for elem in comparisonArray:
            if (elem == True):
                correctTrials += 1
            elif (elem == False):
                wrongTrials += 1

        #by default the wrongness = 1 - correctness
        correctness = (correctTrials / float(len(comparisonArray))) * 100
        wrongness = (wrongTrials / float(len(comparisonArray))) * 100

        print correctness, wrongness

        return correctness