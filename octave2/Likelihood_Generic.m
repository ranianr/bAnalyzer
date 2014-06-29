function [TrainOut likelihoodClass]= Likelihood_Generic(directory, noiseFlag, idealFlag, butterFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,NoneFlag,startD,endD)
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
        warning('off')
        startD = int32(startD);
        endD = int32(endD);
        %warnings('off');
	% Get Raw Data from the file 
	[data, HDR] = getRawData(directory);
        HDR.TRIG = HDR.TRIG +1;
	% Intial values
	Classes = HDR.Classnames;
        nClass = length(Classes);
        classes_no =[];
        for g = 1:nClass
            classes_no = [ classes_no , getClassNumber(HDR,Classes(g)) ]
        end
	% do pre-processing here please 
	if(noiseFlag == 1)
		noise = mean(data')';
		data = bsxfun(@minus, data, noise);
	endif
	
	if(idealFlag == 1)
            if(f1FLag == 1)
                
                [Mu,Beta] = idealFilter_Train(data, HDR,startD, endD);
                
            elseif(f2FLag == 1)
                [Mu,temp] = idealFilter_Train(data, HDR,startD, endD, @min);
                [temp,Beta] = idealFilter_Train(data, HDR,startD, endD, @max);
            %TODO: support F3 to F6 flags
            endif
        endif
        
        if(butterFlag == 1)
            if(f1FLag == 1)
                    x = "before filter"
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
        endif

	% apply LDA or PCA or CSP
	Wlda=0;
	Wpca =0;
	VLDA = [];
	VPCA = [];
        V = [];
	PC_NumPCA = 0;
	PC_NumLDA = 0;
        PC_Num = 0;
	mu1PCA = [];
	mu2PCA = [];
	mu1LDA = [];
	mu2LDA = [];
        mu1 = [];
        mu2 = [];
	PIPCA = [];
	PILDA = [];
        PI = [];
	segmaPCA = [];
	segmaLDA = [];
        segma = [];
	ZLDA = [];
	ZPCA = [];
        Z =[];
        
        
	if(LDAFLag == 1)
		%LDA
		X = [Mu Beta];
		[ZLDA, VLDA]  = LDA_fn(HDR.Classlabel, X, classes_no);
		PC_NumLDA = [];
     
        for g = 1:nClass
            C1 = ZLDA((HDR.Classlabel == g),:);
            C2 = ZLDA((HDR.Classlabel ~= g),:);
            Z = [C1; C2];
            t = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
            accuracy = likelihoodResults(C1, C2, t);
            [AccSelected, AccIndex] = max(accuracy)
            PC_NumLDA =[PC_NumLDA; min(AccIndex)];
           if(g == 1) 
              [PI_c1 segma_c1 mu1_c1 mu2_c1] = Likeli_Classifier_Parameters(PC_NumLDA(g), Z, t);
              PILDA.PI_c1 = PI_c1;
              segmaLDA.segma_c1 = segma_c1;
              mu1LDA.mu1_c1 = mu1_c1;
              mu2LDA.mu2_c1 = mu2_c1;
           elseif(g == 2)
              [PI_c2 segma_c2 mu1_c2 mu2_c2] = Likeli_Classifier_Parameters(PC_NumLDA(g), Z, t);
              PILDA.PI_c2 = PI_c2;
              segmaLDA.segma_c2 = segma_c2;
              mu1LDA.mu1_c2 = mu1_c2;
              mu2LDA.mu2_c2 = mu2_c2;
           elseif(g == 3)
              [PI_c3 segma_c3 mu1_c3 mu2_c3] = Likeli_Classifier_Parameters(PC_NumLDA(g), Z, t);
              PILDA.PI_c3 = PI_c3;
              segmaLDA.segma_c3 = segma_c3;
              mu1LDA.mu1_c3 = mu1_c3;
              mu2LDA.mu2_c3 = mu2_c3;
           elseif(g == 4)
              [PI_c4 segma_c4 mu1_c4 mu2_c4] = Likeli_Classifier_Parameters(PC_NumLDA(g), Z, t);
              PILDA.PI_c4 = PI_c4;
              segmaLDA.segma_c4 = segma_c4;
              mu1LDA.mu1_c4 = mu1_c4;
              mu2LDA.mu2_c4 = mu2_c4;
           elseif(g == 5)
              [PI_c5 segma_c5 mu1_c5 mu2_c5] = Likeli_Classifier_Parameters(PC_NumLDA(g), Z, t);
              PILDA.PI_c4 = PI_c5;
              segmaLDA.segma_c4 = segma_c5;
              mu1LDA.mu1_c4 = mu1_c5;
              mu2LDA.mu2_c4 = mu2_c5;
	   endif
        end
        datalength = size(ZLDA)(1);                
	
        elseif(PCAFlag == 1)
		%PCA
                
		pureData = [Mu, Beta];
		[VPCA, ZPCA]= pcaProject(pureData);
		ZPCA=ZPCA';
		PC_NumPCA = [];
     
        for g = 1:nClass
            C1 = ZPCA((HDR.Classlabel == g),:);
            C2 = ZPCA((HDR.Classlabel ~= g),:);
            Z = [C1; C2];
            t = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
            accuracy = likelihoodResults(C1, C2, t);
            [AccSelected, AccIndex] = max(accuracy)
            PC_NumPCA =[PC_NumPCA; min(AccIndex)];
           if(g == 1) 
              [PI_c1 segma_c1 mu1_c1 mu2_c1] = Likeli_Classifier_Parameters(PC_NumPCA(g), Z, t);
              PIPCA.PI_c1 = PI_c1;
              segmaPCA.segma_c1 = segma_c1;
              mu1PCA.mu1_c1 = mu1_c1;
              mu2PCA.mu2_c1 = mu2_c1;
           elseif(g == 2)
              [PI_c2 segma_c2 mu1_c2 mu2_c2] = Likeli_Classifier_Parameters(PC_NumPCA(g), Z, t);
              PIPCA.PI_c2 = PI_c2;
              segmaPCA.segma_c2 = segma_c2;
              mu1PCA.mu1_c2 = mu1_c2;
              mu2PCA.mu2_c2 = mu2_c2;
           elseif(g == 3)
              [PI_c3 segma_c3 mu1_c3 mu2_c3] = Likeli_Classifier_Parameters(PC_NumPCA(g), Z, t);
              PIPCA.PI_c3 = PI_c3;
              segmaPCA.segma_c3 = segma_c3;
              mu1PCA.mu1_c3 = mu1_c3;
              mu2PCA.mu2_c3 = mu2_c3;
           elseif(g == 4)
              [PI_c4 segma_c4 mu1_c4 mu2_c4] = Likeli_Classifier_Parameters(PC_NumPCA(g), Z, t);
              PIPCA.PI_c4 = PI_c4;
              segmaPCA.segma_c4 = segma_c4;
              mu1PCA.mu1_c4 = mu1_c4;
              mu2PCA.mu2_c4 = mu2_c4;
           elseif(g == 5)
              [PI_c5 segma_c5 mu1_c5 mu2_c5] = Likeli_Classifier_Parameters(PC_NumPCA(g), Z, t);
              PIPCA.PI_c4 = PI_c5;
              segmaPCA.segma_c4 = segma_c5;
              mu1PCA.mu1_c4 = mu1_c5;
              mu2PCA.mu2_c4 = mu2_c5;
	   endif
        end
        	datalength = size(ZPCA)(1);
	elseif(CSP_LDAFlag == 1)
		%NOT working to be reviewed with Raghda or Hemaly !
		%CSP then LDA
		
	elseif(NoneFlag == 1)
		X = [Mu Beta];
                Z = X;
                V=1;
                PC_Num = [];
     
        for g = 1:nClass
            C1 = Z((HDR.Classlabel == g),:);
            C2 = Z((HDR.Classlabel ~= g),:);
            Z = [C1; C2];
            t = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
            accuracy = likelihoodResults(C1, C2, t);
            [AccSelected, AccIndex] = max(accuracy)
            PC_Num =[PC_Num; min(AccIndex)];
           if(g == 1) 
              [PI_c1 segma_c1 mu1_c1 mu2_c1] = Likeli_Classifier_Parameters(PC_Num(g), Z, t);
              PI.PI_c1 = PI_c1;
              segma.segma_c1 = segma_c1;
              mu1.mu1_c1 = mu1_c1;
              mu2.mu2_c1 = mu2_c1;
           elseif(g == 2)
              [PI_c2 segma_c2 mu1_c2 mu2_c2] = Likeli_Classifier_Parameters(PC_Num(g), Z, t);
              PI.PI_c2 = PI_c2;
              segma.segma_c2 = segma_c2;
              mu1.mu1_c2 = mu1_c2;
              mu2.mu2_c2 = mu2_c2;
           elseif(g == 3)
              [PI_c3 segma_c3 mu1_c3 mu2_c3] = Likeli_Classifier_Parameters(PC_Num(g), Z, t);
              PI.PI_c3 = PI_c3;
              segma.segma_c3 = segma_c3;
              mu1.mu1_c3 = mu1_c3;
              mu2.mu2_c3 = mu2_c3;
           elseif(g == 4)
              [PI_c4 segma_c4 mu1_c4 mu2_c4] = Likeli_Classifier_Parameters(PC_Num(g), Z, t);
              PI.PI_c4 = PI_c4;
              segma.segma_c4 = segma_c4;
              mu1.mu1_c4 = mu1_c4;
              mu2.mu2_c4 = mu2_c4;
	   elseif(g == 5)
	      [PI_c5 segma_c5 mu1_c5 mu2_c5] = Likeli_Classifier_Parameters(PC_Num(g), Z, t);
              PI.PI_c4 = PI_c5;
              segma.segma_c4 = segma_c5;
              mu1.mu1_c4 = mu1_c5;
              mu2.mu2_c4 = mu2_c5;
    	   endif
        end
        datalength = size(Z)(1);
	endif
        
	% Returing output structure
        TrainOut.PILDA = PILDA;
	TrainOut.SegmaLDA = segmaLDA;
	TrainOut.mu1LDA = mu1LDA;
	TrainOut.mu2LDA = mu2LDA;
	TrainOut.VLDA = VLDA;
	TrainOut.PC_NumLDA = PC_NumLDA;
        TrainOut.LDAData = ZLDA;
        %------
        TrainOut.PIPCA = PIPCA;
	TrainOut.SegmaPCA = segmaPCA;
	TrainOut.mu1PCA = mu1PCA;
	TrainOut.mu2PCA = mu2PCA;
	TrainOut.VPCA = VPCA;
	TrainOut.PC_NumPCA = PC_NumPCA;
        TrainOut.PCAData = ZPCA;
	%------
        TrainOut.PI = PI;
	TrainOut.Segma = segma;
	TrainOut.mu1 = mu1;
	TrainOut.mu2 = mu2;
	TrainOut.V = V;
	TrainOut.PC_Num = PC_Num;
        TrainOut.NoneData = Z;
        %------
        TrainOut.HDR = HDR;
	TrainOut.Classnames = HDR.Classnames;
	TrainOut.nClass = nClass;
        TrainOut.datalength = datalength;
        TrainOut.ClassesTypes = HDR.Classlabel;
        TrainOut.ClassesTypesSameFile = t';

end


