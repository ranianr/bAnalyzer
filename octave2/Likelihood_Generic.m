function TrainOut = Likelihood_Generic(directory, noiseFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,CSPFlag,startD,endD)
%{

example call
use normal getMuBeta .. PCA .. start at 3 .. end at 7 
TrainOut = Likelihood_Generic("../Osama Mohamed.csv",1,0,0,0,0,0,0,1,0,0,3,7 ); 

directory = data file path

f1FLag = getMuBeta
f2Flag = GetMuBeta_more_feature 
f3Flag = GetMuBeta_more_feature2 -> get min Mu, max Beta
f4Flag = GetMuBeta_more_feature3 -> get min Mu, max Beta, mean Mu, mean Beta 
f5Flag = GetMuBeta_more_feature4 -> get min Mu, max Mu, min Beta, max Bita
f6Flag = GetMuBeta_more_feature5 -> get min Mu, max Mu, min Beta, max Bita, mean Mu, mean Beta

LDAFLag = use LDA
PCAFlag = use PCA
CSP_LDAFlag = use CSP then LDA
CSPFlag = use CSP 


signal starts at 3 and ends at 7 (4 seconds)
startD = start time for the trial enter number between 3 to 7 
endD = end of trial signal
%}

	% Get Raw Data from the file 
	[data, HDR] = getRawData(directory);
        
	% Intial values
	classes_no = [ getClassNumber(HDR,'RIGHT')  getClassNumber(HDR,'LEFT') ];
        
	% do pre-processing here please 
	if(noiseFlag == 1)
		noise = mean(data')';
		data = bsxfun(@minus, data, noise);
	endif
	
	% Get features (mu & beta) according to the selected method
	if(f1FLag == 1)
		[Mu,Beta] =  GetMuBeta(startD, endD, data, HDR);
	elseif (f2FLag == 1)
		[Mu,Beta] =  GetMuBeta_more_feature(startD, endD, data, HDR);
	elseif (f3FLag == 1)
		[Mu,Beta] =  GetMuBeta_more_feature2(startD, endD, data, HDR);
	elseif (f4FLag == 1)
		[Mu,Beta] =  GetMuBeta_more_feature3(startD, endD, data, HDR);
	elseif (f5FLag == 1)
		[Mu,Beta] =  GetMuBeta_more_feature4(startD, endD, data, HDR);
	elseif (f6FLag == 1)
		[Mu,Beta] =  GetMuBeta_more_feature5(startD, endD, data, HDR);
	endif

	% apply LDA or PCA or CSP
	Wlda=0;
	Wpca =0;
	if(LDAFLag == 1)
		%LDA
		X = [Mu Beta];
		[Z, V]  = LDA_fn(HDR.Classlabel, X, classes_no);
		C1 = Z((HDR.Classlabel==1),:);
		C2 = Z((HDR.Classlabel==2),:);
		Z = [C1; C2];
		t = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
		accuracy = likelihoodResults(C1, C2, t)
		[AccSelected, AccIndex] = max(accuracy)
		PC_Num = min(AccIndex)
		[PI segma mu1 mu2] = Likeli_Classifier_Parameters(PC_Num, Z, t);
	elseif(PCAFlag == 1)
		%PCA
		pureData = [Mu, Beta];
		[V, Z]= pcaProject(pureData);
		Z=Z';
		C1 = Z((HDR.Classlabel==1),:);
		C2 = Z((HDR.Classlabel==2),:);
		Z = [C1; C2];
		t = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
		accuracy = likelihoodResults(C1, C2, t)
		[AccSelected, AccIndex] = max(accuracy)
		PC_Num = min(AccIndex)
		[PI segma mu1 mu2] = Likeli_Classifier_Parameters(PC_Num, Z, t);
	elseif(CSP_LDAFlag == 1)
		%NOT working to be reviewed with Raghda or Hemaly !
		%CSP then LDA
		
	elseif(CSPFlag == 1)
		%not tested
	endif
        
	% Returing output structure
	TrainOut.V = V;
	TrainOut.Wlda = Wlda(1:end-1);
	TrainOut.Wolda = Wlda(end);
	TrainOut.Wpca = Wpca(1:end-1);
	TrainOut.Wopca = Wpca(end);

	TrainOut.PC_Num = PC_Num;
	TrainOut.HDR = HDR;

end

