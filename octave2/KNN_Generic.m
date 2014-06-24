function TrainOut = KNN_Generic(directory, noiseFlag, idealFlag, butterFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,NoneFlag,startD,endD)
%{

example call
use remove noise .. getMuBeta .. PCA .. start at 0 .. end at 4
TrainOut = KNN_Generic("../Osama Mohamed.csv",1,1,0,0,0,0,0,0,1,0,0,0,4 ); 

directory = data file path

f1FLag = getMuBeta
f2Flag = GetMuBeta_more_feature 
f3Flag = GetMuBeta_more_feature2 -> get min Mu, max Beta
f4Flag = GetMuBeta_more_feature3 -> get min Mu, max Beta, mean Mu, mean Beta 
f5Flag = GetMuBeta_more_feature4 -> get min Mu, max Mu, min Beta, max Beta
f6Flag = GetMuBeta_more_feature5 -> get min Mu, max Mu, min Beta, max Beta, mean Mu, mean Beta

LDAFLag = use LDA
PCAFlag = use PCA
CSP_LDAFlag = use CSP then LDA
NoneFlag = use CSP 


signal starts at 3 and ends at 7 (4 seconds)
startD = start time for the trial enter number between 3 to 7 
endD = end of trial signal
%}

        startD = int32(startD);
        endD = int32(endD);

	% Get Raw Data from the file 
	[data, HDR] = getRawData(directory);
        
	% Intial values
	classes_no = [ getClassNumber(HDR,'RIGHT')  getClassNumber(HDR,'LEFT') ];
        
	% do pre-processing here please 
	if(noiseFlag == 1)
		noise = mean(data')';
		data =  data -noise;	
	endif
        
	% Get features (mu & beta) according to the selected method
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
	KLDA = 0;
	KPCA = 0;
        K=0;
        X=[];
        t=[];
	ZLDA = [];
	ZPCA = [];
	VPCA = [];
	VLDA = [];
	PC_NumLDA = 0;
	PC_NumPCA = 0;
        PC_Num = 0;
        datalength = 0;
	
	if(LDAFLag == 1)
		%LDA
		X = [Mu Beta];
		[ZLDA, VLDA]  = LDA_fn(HDR.Classlabel, X, classes_no);
		C1 = ZLDA((HDR.Classlabel==1),:);
		C2 = ZLDA((HDR.Classlabel==2),:);
		ZLDA = [C1; C2];
		t = [ones(size(C1)(1),1) ; 2*ones(size(C2)(1),1)]';
		[accuracy k_total] = knnResults(ZLDA, t);
		[AccSelected, AccIndex] = max(accuracy);
		PC_NumLDA = min(AccIndex);
		KLDA = k_total(PC_NumLDA);
        	datalength = size(ZLDA)(1);
	elseif(PCAFlag == 1)
		%PCA
		pureData = [Mu, Beta];
		[VPCA, ZPCA]= pcaProject(pureData);
                t=HDR.Classlabel;
		[accuracy k_total] = knnResults(ZPCA', HDR.Classlabel);
		[AccSelected, AccIndex] = max(accuracy);
		PC_NumPCA = min(AccIndex);
		KPCA = k_total(PC_NumPCA);
                % make zpca consistent with zlda!
                ZPCA = ZPCA';
        	datalength = size(ZPCA)(1);		
	
        elseif(CSP_LDAFlag == 1)
		%NOT working to be reviewed with Raghda or Hemaly !
		%CSP then LDA
		
      
	elseif(NoneFlag == 1)
                
		X = [Mu Beta]';
                t=HDR.Classlabel;
                [accuracy k_total] = knnResults(X', HDR.Classlabel);
              
		[AccSelected, AccIndex] = max(accuracy);
		PC_Num = min(AccIndex);
		K = k_total(PC_Num);
                % make zpca consistent with zlda!
                
        	datalength = size(X)(1)
                
	endif
        
	% Returing output structure
        
        %%% adding a new variable to the struct is as easy as the following line
        %TrainOut.lol = "haha";
        %%% if we ever wanted to comment multi-lines, use % instead of %{ and %}
        
	TrainOut.KPCA = KPCA;
	TrainOut.KLDA = KLDA;
        TrainOut.K = K;
	
        % is this used anywhere!?
	TrainOut.ZtrainLDA = ZLDA;
	TrainOut.ZtrainPCA = ZPCA;
        TrainOut.Z = X;
	
	TrainOut.VPCA = VPCA;
	TrainOut.VLDA = VLDA;
	
	TrainOut.PC_NumPCA = PC_NumPCA;
	TrainOut.PC_NumLDA = PC_NumLDA;
        TrainOut.PC_Num = PC_Num;
	
        TrainOut.ClassLabels = t;
        
        TrainOut.PCAData = ZPCA;
        TrainOut.LDAData = ZLDA;
        TrainOut.NoneData = X;
        TrainOut.datalength = datalength;

        TrainOut.ClassesTypes = HDR.Classlabel;
        TrainOut.ClassesTypesSameFile = t';

end

