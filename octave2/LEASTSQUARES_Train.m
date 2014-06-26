function [TrainOut ] = LEASTSQUARES_Train(directory, path="Classifiers/")
    % Add pathes of needed functions
	addpath([path 'Functions']);
	addpath([path 'RawDataFunctions']);
    	
    % Get Raw Data from the file 
	[data, HDR] = getRawData(directory);
        HDR.TRIG = HDR.TRIG +1;
    % Intial values
	classes_no = [ getClassNumber(HDR,'RIGHT')  getClassNumber(HDR,'LEFT') ];
    
    % do pre-processing here please 
	noise = mean(data')';
	data = bsxfun(@minus, data, noise);

    % Get features (mu & beta)
	%[Mu,Beta] = GetMuBeta_new_filt(data, HDR);
        [Mu,Beta] = idealFilter_Train(data, HDR);
    % apply LDA method to the features
	X = [Mu Beta];
	%[Z, V] = LDA_fn(HDR.Classlabel, X, classes_no);
	%[V, Z] = pcaProject(X);
	Z=X;
	V=1;
    % Get the classifier parameters here
	accuracy = leastSquaresResults(Z, HDR.Classlabel)
	[AccSelected, AccIndex] = max(accuracy)
	PC_Num = AccIndex(1);
        %PC_Num = 4*14;
 	W  = Least_Classifier_Parameters(PC_Num, Z, HDR.Classlabel);
    
    % Returing output structure
	TrainOut.V = V;
	TrainOut.W = W(1:end-1);
	TrainOut.Wo = W(end);
	TrainOut.PC_Num = PC_Num;
	TrainOut.HDR = HDR;
end