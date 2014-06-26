function TrainOut = LIKELIHOOD_Train(directory, path="Classifiers/")
    % Add pathes of needed functions
	addpath([path 'Functions']);
	addpath([path 'RawDataFunctions']);
	%addpath([path 'wavelet']);

    
    % Get Raw Data from the file
	[data, HDR] = getRawData(directory);
  HDR.TRIG = HDR.TRIG +1;

	%{
	[icasig,  A, Wica] = fastica(data', 'approach', 'symm', 'g', 'pow3','stabilization','on','initGuess',0.2,'sampleSize', 0.89);
	size(icasig)
	size(A)
	size(Wica)
	%[icasig, A, Wica] = fastica(data);
    		data = icasig';
 	%}
    % Intial values
	classes_no = [ getClassNumber(HDR,'RIGHT')  getClassNumber(HDR,'LEFT') ];
    
    % do pre-processing here please
	noise = mean(data')';
	data =  data -noise;
%%    	data = [data, noise];
    % Get features (mu & beta)
	[Mu,Beta] =  waveletFeature_Train(data, HDR);
    
    % apply LDA method to the features
	X = [Mu Beta];
	[Z, V]  = LDA_fn(HDR.Classlabel, X, classes_no);
    %Z = X;
    % Get the classifier parameters here
	C1 = Z((HDR.Classlabel==1),:);
  C2 = Z((HDR.Classlabel==2),:);
	Z = [C1; C2];
  t = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
	accuracy = likelihoodResults(C1, C2, t)
	[AccSelected, AccIndex] = max(accuracy)
	PC_Num = min(AccIndex)
	[PI segma mu1 mu2] = Likeli_Classifier_Parameters(PC_Num, Z, t);
    
    % Returing output structure
	TrainOut.PI = PI;
	TrainOut.Segma = segma;
	TrainOut.mu1 = mu1;
	TrainOut.mu2 = mu2;
	TrainOut.V = V;
	TrainOut.PC_Num = PC_Num;
	TrainOut.ClassLabels = t;
end

