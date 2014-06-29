import os

#Training folder
MainFolder = os.getcwd()
OctaveFolder = MainFolder + "/octave2"

#Debugging Configuration

#TrainingFile =  "/home/rho/Documents/GP/bAnalyzer/master/Data/Training/OldData/[T][2014-01-15 15-02-52] Mohamed Nour El-Din.csv"
#DetectionFile = "/home/rho/Documents/GP/bAnalyzer/master/Data/Detection/oldData/[D][2014-03-01 16-48-36] Mohamed Nour El-Din.csv"

TrainingFile = "/home/rho/Documents/GP/bAnalyzer/master/Data/Training/Session_2014_06_23_61827/[T][2014-06-23 17-28-14] Walid Ezzat.csv"
DetectionFile ="/home/rho/Documents/GP/bAnalyzer/master/Data/Detection/[D][2014-06-23 17-34-09] Walid Ezzat.csv"

#TrainingFile = MainFolder + "/Data/Training/OldData/[T][2014-01-15 19-41-58] Ahmed Hemaly.csv"

#DetectionFile =  MainFolder + "/Data/Training/OldData/[T][2014-01-15 19-41-58] Ahmed Hemaly.csv"




#Default Session's Options
#Single trials
SampleStart = 0
SampleEnd = 4

####---Methods---####
#Noise
NoiseRemoval = True

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
FeatureEnhancementMethod = _CSP

#Classification
_Fisher = 0
_KNN = 1
_Likelihood = 2
_LeastSquares = 3
ClassificationMethod = _Likelihood

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

