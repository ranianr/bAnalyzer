function TrainOut = Leastsquares_Generic(directory, noiseFlag, idealFlag, butterFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,NoneFlag,startD,endD)
%{

example call
use normal getMuBeta .. PCA .. start at 3 .. end at 7 
TrainOut = Leastsquares_Generic("../Osama Mohamed.csv",1,0,0,0,0,0,0,1,0,0,3,7 ); 

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
NoneFlag = use CSP 


signal starts at 3 and ends at 7 (4 seconds)
startD = start time for the trial enter number between 3 to 7 
endD = end of trial signal
%}
        warning('off')
        startD = int32(startD);
        endD = int32(endD);

	% Get Raw Data from the file 
	[data, HDR] = getRawData(directory);
        HDR.TRIG = HDR.TRIG +1;
        
	% Intial values
	Classes = HDR.Classnames;
        nClass = length(Classes);
        classes_no =[];
        for g = 1:nClass
            classes_no = [ classes_no , getClassNumber(HDR,Classes(g)) ];
        end
        
	% do pre-processing here please 
	if(noiseFlag == 1)
		noise = mean(data')';
		data = bsxfun(@minus, data, noise);
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
	VLDA = 0;
	VPCA = [];
	PC_NumPCA = 0;
	PC_NumLDA = 0;
        W=0;
        V=0;
        PC_Num=0;
        Z=[];
        ZLDA = [];
	ZPCA = [];
        
	if(LDAFLag == 1)
		%LDA
		X = [Mu Beta];
		[ZLDA, VLDA]  = LDA_fn(HDR.Classlabel, X, classes_no);
		accuracy = leastSquaresResults(ZLDA, HDR.Classlabel);
		[AccSelected, AccIndex] = max(accuracy);
		PC_NumLDA = min(AccIndex)
	 	ClassesData = zeros(size(ZLDA)(1)/nClass,PC_NumLDA,nClass);
                Wlda = zeros(nClass,PC_NumLDA+1);
                for g = 1:nClass           
                    ClassesData(:,:,g)  = ZLDA(HDR.Classlabel == classes_no(g),1:PC_NumLDA);
                    temp                = ZLDA(HDR.Classlabel ~= classes_no(g),1:PC_NumLDA);
                    labels              = [ones(1,size(ClassesData(:,:,g))(1)) 2*ones(1,size(temp)(1))];
                    Wlda(g,:)              = Least_Classifier_Parameters(PC_NumLDA, [ClassesData(:,:,g) ;temp], labels);
                end
        	datalength = size(ZLDA)(1);                
	
	elseif(PCAFlag == 1)
		%PCA
		pureData = [Mu, Beta];
		[VPCA, ZPCA]= pcaProject(pureData);
                size(ZPCA)
		accuracy = leastSquaresResults(ZPCA', HDR.Classlabel);
		[AccSelected, AccIndex] = max(accuracy)
		PC_NumPCA = min(AccIndex)
                ZPCA = ZPCA';
                ClassesData = zeros(size(ZPCA)(1)/nClass,PC_NumPCA,nClass);
                Wpca = zeros(nClass,PC_NumPCA+1);
                for g = 1:nClass           
                    ClassesData(:,:,g)  = ZPCA(HDR.Classlabel == classes_no(g),1:PC_NumPCA);
                    temp                = ZPCA(HDR.Classlabel ~= classes_no(g),1:PC_NumPCA);
                    labels              = [ones(1,size(ClassesData(:,:,g))(1)) 2*ones(1,size(temp)(1))];
                    Wpca(g,:)              = Least_Classifier_Parameters(PC_NumPCA, [ClassesData(:,:,g) ;temp], labels);
                end
                
        	datalength = size(ZPCA)(1);

	elseif(CSP_LDAFlag == 1)
		%NOT working to be reviewed with Raghda or Hemaly !
		%CSP then LDA
		
	elseif(NoneFlag == 1)
		X = [Mu Beta];
                Z = X;
                V=1;
                PC_Num = 2*14;
                %accuracy = leastSquaresResults(Z, HDR.Classlabel);
		%[AccSelected, AccIndex] = max(accuracy);
		%PC_Num =min(AccIndex)
                
                ClassesData = zeros(size(X)(1)/nClass,PC_Num,nClass);
                W = zeros(nClass,PC_Num+1);
                
                for g = 1:nClass           
                    ClassesData(:,:,g)  = X(HDR.Classlabel == classes_no(g),1:PC_Num);
                    temp                = X(HDR.Classlabel ~= classes_no(g),1:PC_Num);
                    labels              = [ones(1,size(ClassesData(:,:,g))(1)) 2*ones(1,size(temp)(1))];
                    W(g,:)              = Least_Classifier_Parameters(PC_Num, [ClassesData(:,:,g) ;temp], labels);
                end
                
                datalength = size(Z)(1);
                
	endif
        
	% Returing output structure

        TrainOut.V = V;
	TrainOut.VPCA = VPCA;
	TrainOut.VLDA = VLDA;
	
        TrainOut.W = W(:,1:end-1);
	TrainOut.Wo = W(:,end);
        
        TrainOut.Wlda = Wlda(:,1:end-1);
	TrainOut.Wolda = Wlda(:,end);
	TrainOut.Wpca = Wpca(:,1:end-1);
	TrainOut.Wopca = Wpca(:,end);
        TrainOut.PC_Num = PC_Num;
	TrainOut.PC_NumPCA = PC_NumPCA;
	TrainOut.PC_NumLDA = PC_NumLDA;
        TrainOut.PCAData = ZPCA;
        TrainOut.LDAData = ZLDA;
        TrainOut.NoneData = Z;
        TrainOut.datalength = datalength;
        TrainOut.ClassesTypes = HDR.Classlabel;
        TrainOut.HDR = HDR;
        TrainOut.Classnames = HDR.Classnames;
        TrainOut.nClass = nClass;
end


