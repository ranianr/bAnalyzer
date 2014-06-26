function realClassesDetection = getRealClass(directory)
    [Data, HDR] = getRawData(directory);
    realClassesDetection = HDR.Classlabel
    
end