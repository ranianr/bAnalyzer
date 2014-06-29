import os
import AppConfig as AC

#TODO: generalize the compacting to all the AppConfigs

#Noise
_Remove =	1<<0
_Raw = 		1<<1
NoiseRemoval = _Remove 
NoiseRemovalAll = True

#Extraction
_Mean = 	1<<0
_LMhB = 	1<<1
_LMhBm = 	1<<2
_LMBhMB = 	1<<3
_LMBhMBm = 	1<<4
FeaturesMethod = _Mean
FeaturesAll = False

#Enhancement
_PCA = 1<<0
_LDA = 1<<1
_None = 1<<2
EnhancementMethod = _PCA | _LDA
EnhancementAll = True

#Classification
_Fisher = 	1<<0
_KNN = 		1<<1
_Likelihood = 	1<<2
_LeastSquares = 1<<3
ClassificationMethod = _LeastSquares
ClassificationAll = False

#Processing
_Butter = 1<<0
_Ideal = 1<<1
PreprocessingMethod = _Ideal | _Butter
PreprocessingAll = True

#Directories

TrainDir = AC.MainFolder + "/Data/Training/Session_2014_06_23_61827/"
DetectDir = AC.MainFolder + "/Data/Detection/"

#Online database update
UpdateGDocs = True