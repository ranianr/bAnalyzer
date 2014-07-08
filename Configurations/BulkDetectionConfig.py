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
EnhancementMethod = _PCA | _LDA | _None
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

TrainPath = AC.MainFolder  + "/Data/Session_2014_07_01_62730/[T][2014-07-01 17-31-07] Osama Mohamed.csv"

DetectPath = AC.MainFolder + "/Data/[D][2014-07-01 17-36-12] Osama Mohamed.csv"

#Online database update
UpdateGDocs = True