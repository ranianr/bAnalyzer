import os

#Scripts
#TODO: we should get the installation directory to locate relative to it according to the AppConfig
#otherwise the current program behaves only if we're excuting from the master's directory
ScriptsFolder           = "octave2/FeaturePlottingScripts"
PlottingFunctionsPath   = ScriptsFolder + "/PlottingFunctions"
OctaveDataFunction      = "GetDataAnalysis"
RawDataFunctions        = "octave2"

MuMin   = 10
MuMax   = 12
BetaMin = 16
BetaMax = 24