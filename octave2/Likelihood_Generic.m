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

        startD = int32(startD);
        endD = int32(endD);
        %warnings('off');
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
	VLDA = [];
	VPCA = [];
	PC_NumPCA = 0;
	PC_NumLDA = 0;

	mu1PCA = [];
	mu2PCA = [];
	mu1LDA = [];
	mu2LDA = [];

	PIPCA = [];
	PILDA = [];

	segmaPCA = [];
	segmaLDA = [];

	ZLDA = [];
	ZPCA = [];

	if(LDAFLag == 1)
		%LDA
		X = [Mu Beta];
		[ZLDA, VLDA]  = LDA_fn(HDR.Classlabel, X, classes_no);
		C1 = ZLDA((HDR.Classlabel==1),:);
		C2 = ZLDA((HDR.Classlabel==2),:);
		ZLDA = [C1; C2];
		t = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
		accuracy = likelihoodResults(C1, C2, t);
                
		[AccSelected, AccIndex] = max(accuracy);
		PC_NumLDA = min(AccIndex);
		[PILDA segmaLDA mu1LDA mu2LDA] = Likeli_Classifier_Parameters(PC_NumLDA, ZLDA, t);
        	datalength = size(ZLDA)(1);                
	elseif(PCAFlag == 1)
		%PCA
		pureData = [Mu, Beta];
		[VPCA, ZPCA]= pcaProject(pureData);
		ZPCA=ZPCA';
		C1 = ZPCA((HDR.Classlabel==1),:);
		C2 = ZPCA((HDR.Classlabel==2),:);
		ZPCA = [C1; C2];
		t = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
		accuracy = likelihoodResults(C1, C2, t);
		[AccSelected, AccIndex] = max(accuracy);
		PC_NumPCA = min(AccIndex);
		[PIPCA segmaPCA mu1PCA mu2PCA] = Likeli_Classifier_Parameters(PC_NumPCA, ZPCA, t);
        	datalength = size(ZPCA)(1);
	elseif(CSP_LDAFlag == 1)
		%NOT working to be reviewed with Raghda or Hemaly !
		%CSP then LDA
		
	elseif(CSPFlag == 1)
		%not tested
	endif
        
	% Returing output structure
	TrainOut.VPCA = VPCA;
	TrainOut.VLDA = VLDA;
	
	TrainOut.Wlda = Wlda(1:end-1);
	TrainOut.Wolda = Wlda(end);
	
	TrainOut.Wpca = Wpca(1:end-1);
	TrainOut.Wopca = Wpca(end);

	TrainOut.PC_NumPCA = PC_NumPCA;
	TrainOut.PC_NumLDA = PC_NumLDA;

	TrainOut.mu1PCA = mu1PCA;
	TrainOut.mu2PCA = mu2PCA;
	TrainOut.mu1LDA = mu1LDA;
	TrainOut.mu2LDA = mu2LDA;

	TrainOut.PIPCA = PIPCA;
	TrainOut.PILDA = PILDA;

	TrainOut.segmaPCA = segmaPCA;
	TrainOut.segmaLDA = segmaLDA;

	TrainOut.HDR = HDR;

        TrainOut.PCAData = ZPCA;
        TrainOut.LDAData = ZLDA;
        TrainOut.datalength = datalength;

        TrainOut.ClassesTypes = HDR.Classlabel;

end


