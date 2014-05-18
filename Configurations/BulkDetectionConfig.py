import os

#TODO: generalize the compacting to all the AppConfigs

#Noise
_Remove =	1<<0
_Raw = 		1<<1
NoiseRemoval = _Remove | _Raw
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
_CSP = 1<<2
EnhancementMethod = _PCA | _LDA
EnhancementAll = True

#Classification
_Fisher = 	1<<0
_KNN = 		1<<1
_Likelihood = 	1<<2
_LeastSquares = 1<<3
ClassificationMethod = _Fisher
ClassificationAll = False

#Processing
_Method1 = 1<<0
_Method2 = 1<<1
PreprocessingMethod = _Method1
PreprocessingAll = True

