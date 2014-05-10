function TrainOut = KNN_Generic(directory, noiseFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,CSPFlag,startD,endD)
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
CSPFlag = use CSP 


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
	KLDA = 0;
	KPCA = 0;
	ZLDA = [];
	ZPCA = [];
	VPCA = [];
	VLDA = [];
	PC_NumLDA = 0;
	PC_NumPCA = 0;
	
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
		Trials_Mu   = getTrials(Mu, HDR);
	        Trials_Beta = getTrials(Beta, HDR);
		RIGHT_ClassNumber   = getClassNumber(HDR, "RIGHT");
		LEFT_ClassNumber    = getClassNumber(HDR, "LEFT");
	       	ClassLabels = [RIGHT_ClassNumber; LEFT_ClassNumber];
	    	c = HDR.Classlabel;
	    	Xoriginal = [Trials_Mu , Trials_Beta];
	    	%% LDA function calling
	    	C1 = Xoriginal(HDR.Classlabel==1,:);
		C2 = Xoriginal(HDR.Classlabel==2,:);
	    	[Z, W] = CSP_fn(C1, C2);
	        [VLDA, Xm, Vproj]  = LDA_fn(c, Z, ClassLabels);
		z1 = V(:,1);
		z2 = V(:,2);
		z3 = V(:,4);
		Z = V;
       	        accuracy = getAccuracy(Z, HDR);	
       	        
	elseif(CSPFlag == 1)
		%not tested
	endif
        
	% Returing output structure
        
        %%% adding a new variable to the struct is as easy as the following line
        %TrainOut.lol = "haha";
        %%% if we ever wanted to comment multi-lines, use % instead of %{ and %}
        
	TrainOut.KPCA = KPCA;
	TrainOut.KLDA = KLDA;
	
        % is this used anywhere!?
	TrainOut.ZtrainLDA = ZLDA;
	TrainOut.ZtrainPCA = ZPCA;
	
	TrainOut.VPCA = VPCA;
	TrainOut.VLDA = VLDA;
	
	TrainOut.PC_NumPCA = PC_NumPCA;
	TrainOut.PC_NumLDA = PC_NumLDA;
	
        TrainOut.ClassLabels = HDR.Classlabel;
        
        TrainOut.PCAData = ZPCA;
        TrainOut.LDAData = ZLDA;
        TrainOut.datalength = datalength;

        TrainOut.ClassesTypes = HDR.Classlabel;

end
function accuracy = getAccuracy(projected, HDR)
    accuracy = [];
    projected = real(projected)';
    
    for n = 1:size(projected)(1)
        C1=[];
        C2=[];
        
        for k = 1:n
            C1 = [ C1 ; projected(k, :)(HDR.Classlabel==1)];
            C2 = [ C2 ; projected(k, :)(HDR.Classlabel==2)];
        end     
        t = [ones(size(C1)(2),1) ; -1*ones(size(C2)(2),1)];
        dataTotal = [C1,  C2]';
        k = KNNtrain(dataTotal, t)
	acc = KNNtest (k, dataTotal, t, dataTotal, t);
    	accuracy = [accuracy , acc];
    end
end

