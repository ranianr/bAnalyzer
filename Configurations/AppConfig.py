import os

#Training folder
MainFolder = os.getcwd()
OctaveFolder = MainFolder + "/octave2"

#Debugging Configuration

TrainingFile = MainFolder + "/Data/Training/Session_2014_05_18_65914/[T][2014-05-18 18-22-30] Ahmed Hemaly.csv"
DetectionFile = MainFolder + "/Data/Detection/Session_2014_05_18_65914/[D][2014-05-18 18-28-03] Ahmed Hemaly2.csv"

#TrainingFile = "/home/rho/Documents/GP/[2014-03-23] Braingizer/Data/TrainingData/Session_2014_05_06_84005/[T][2014-05-10 19-25-38] Osama Mohamed.csv"
#DetectionFile ="/home/rho/Documents/GP/[2014-03-23] Braingizer/Data//DetectionData/[D][2014-05-10 19-34-11] Osama Mohamed.csv"

#TrainingFile = MainFolder + "/Osama Mohamed.csv"
#DetectionFile = MainFolder + "/Osama Mohamed.csv"


#Default Session's Options
#Single trials
SampleStart = 0
SampleEnd = 4

####---Methods---####
#Noise
NoiseRemoval = False

#Extraction
#those names can't be anything near to a readable variable!! stick to numbers
# 0 mean
# 1 Min MU and Max Beta
# 2 Min Mu, Max Beta, Mean Mu, Mean Beta
# 3 Min Mu Max Mu Min Beta Max Beta
# 4 Min Mu, max Mu, Min Beta, Max Beta, Mean Mu, Mean Beta
ExtractionMethod = 0

#Enhancement
_PCA = 0
_LDA = 1
_CSP = 2
FeatureEnhancementMethod = _PCA

#Classification
_Fisher = 0
_KNN = 1
_Likelihood = 2
_LeastSquares = 3
ClassificationMethod = _Fisher

#Processing
_Method1 = 0
_Method2 = 1
PreprocessingMethod = _Method1

####---MethodsEnd----####

#Same file based flags
SameFileFlag = False
All = False
Offset0 = False
Offset1 = False
Offset2 = False
Offset3 = False
Offset4 = False

