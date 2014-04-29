function [DetectOut Debug] = KNN_Generic_Detect(noiseFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,CSPFlag)
   
 %{
 [DetectOut Debug] = KNN_Generic_Detect(1, 1,0,0,0,0,0,0,1,0,0);
 
 %}  
 	warning('off');
 	%TESTING AND DEBUGGING
 	[Data, HDR] = getRawData("../Osama Mohamed.csv");
 	TRIG = HDR.TRIG(5);
    DetectIn.("TrialData") = getTrialData(Data, TRIG, 5, length(HDR.TRIG));
 	
 	%to test PCA flag use KNN_Generic("../Osama Mohamed.csv",1,1,0,0,0,0,0,0,1,0,0,0,4 );
 	%to test LDA flag use KNN_Generic("../Osama Mohamed.csv",1,1,0,0,0,0,0,1,0,0,0,0,4 );
 	%TODO change this behavior of debugging/testing :'/
 	TrainOut = KNN_Generic("../Osama Mohamed.csv",1,1,0,0,0,0,0,0,1,0,0,0,4 ); 
 	DetectIn.("TrainOut") = TrainOut;
 	
    % Get inputs from python
	TrialData = DetectIn.("TrialData"); %data to be sent from python
	TrainOut = DetectIn.("TrainOut"); %
   
	KPCA = TrainOut.KPCA;
	KLDA = TrainOut.KLDA;

	VPCA = TrainOut.VPCA ;
	VLDA = TrainOut.VLDA ;
	
    ZtrainPCA  = TrainOut.ZtrainPCA;
    ZtrainLDA  = TrainOut.ZtrainLDA;
    
	PC_NumPCA  = TrainOut.PC_NumPCA;
	PC_NumLDA  = TrainOut.PC_NumLDA;

    ClassLabels = TrainOut.ClassLabels;%class labels

    ClassLabels(ClassLabels == 2) = -1;

    
    % do pre-processing here please
    if(noiseFlag == 1)
		noise = mean(TrialData')';
		TrialData =  TrialData -noise;
    endif

	% Get features (mu & beta) according to the selected method
	if(f1FLag == 1)
		[Mu,Beta] =  GetMuBeta_detect(TrialData);
	elseif (f2FLag == 1)
		[Mu,Beta] =  GetMuBeta_detect_more_feature( TrialData);
	elseif (f3FLag == 1)
		[Mu,Beta] =  GetMuBeta_detect_more_feature2(  TrialData);
	elseif (f4FLag == 1)
		[Mu,Beta] =  GetMuBeta_detect_more_feature3(  TrialData);
	elseif (f5FLag == 1)
		[Mu,Beta] =  GetMuBeta_detect_more_feature4( TrialData);
	elseif (f6FLag == 1)
		[Mu,Beta] = GetMuBeta_detect_more_feature5(  TrialData);
	endif
	%defualt return
	TargetsLDA="Unknown";
	TargetsPCA="Unknown";
	
    % apply LDA method to the features
	if(LDAFLag == 1)
		Z = [Mu Beta]*real(VLDA); 
        Z = Z(:,1:PC_NumLDA);
        ZtrainLDA = ZtrainLDA(:,1:PC_NumLDA);

		% apply the classifier here
		if(size(Z)(2) == 1)
			ZtrainLDA = [ZtrainLDA, ZtrainLDA];
			Z = [Z, Z];
		end 

		pointDistance = distancePoints(Z, ZtrainLDA); 
		distance = pointDistance';
		[dist index1] = sort(distance);
        nearestK = dist(2:KLDA+1);
        nearestPointsIndex = index1(2:KLDA+1);
        Ktargets = ClassLabels(nearestPointsIndex);
        vote = sum(Ktargets);
        Yp = 0;%add else error = error +1
        
        if(vote > 0)
            TargetsLDA =  'RIGHT';
        elseif(vote < 0)
            TargetsLDA = 'LEFT';
        else 
            single_target = ClassLabels( distance == min(distance(2:KLDA+1)));
			if(single_target > 0)
			TargetsLDA =  'RIGHT';
			else
			TargetsLDA = 'LEFT';
			end
        end
    endif
    
    
    if(PCAFlag == 1)
    	Z = [Mu Beta]*real(VPCA);
        
        Z = Z(:,1:PC_NumPCA);
        ZtrainPCA = ZtrainPCA';
        ZtrainPCA = ZtrainPCA(:,1:PC_NumPCA);

        % apply the classifier here
        if(size(Z)(2) == 1)
                ZtrainPCA = [ZtrainPCA, ZtrainPCA];
                Z = [Z, Z];
        end
        
        pointDistance = distancePoints(Z, ZtrainPCA); 
        distance = pointDistance';
        [dist index1] = sort(distance);
        %dist = dist';
        nearestK = dist(2:KPCA+1);
        nearestPointsIndex = index1(2:KPCA+1);
        Ktargets = ClassLabels(nearestPointsIndex);
        vote = sum(Ktargets);
        Yp = 0;%add else error = error +1
        
        if(vote > 0)
            TargetsPCA =  'RIGHT';
        elseif(vote < 0)
            TargetsPCA = 'LEFT';
        else 
            single_target = ClassLabels( distance == min(distance(2:KPCA+1)));
            if(single_target > 0)
                TargetsPCA =  'RIGHT';
            else
                TargetsPCA = 'LEFT';
            end
        end
    endif
    %TODO check non of the CSP, LDA nor CSP flags raised 
    % Debug
	Debug = vote;

    %DetectOut
	DetectOut.LDAresult = TargetsLDA;
	DetectOut.PCAresult = TargetsPCA;
end
