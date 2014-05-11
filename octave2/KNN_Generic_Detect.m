function DetectOut = KNN_Generic_Detect(DetectIn, directory, noiseFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,CSPFlag, preProjectedFlag)
   
 %{
 [DetectOut Debug] = KNN_Generic_Detect(1, 1,0,0,0,0,0,0,1,0,0);
 
 %}
 	%warning('off');
        %may be useful later
 	%[Data, HDR] = getRawData(directory);
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

    if (preProjectedFlag == 0)
        % do pre-processing here please
        if(noiseFlag == 1)
                    noise = mean(TrialData')';
                    TrialData =  TrialData -noise;
        endif

        % Get features (mu & beta) according to the selected method
        if(f1FLag == 1)
            [Mu,Beta] =  GetMuBeta_detect(TrialData);
        elseif (f2FLag == 1)
            % a stub is being used here, should implemented first before calling
            % reason: inconsistant filename with fn name
            [Mu,Beta] = GetMuBeta_detect_more_feature(TrialData);
        elseif (f3FLag == 1)
            % a stub is being used here, should implemented first before calling            
            [Mu,Beta] = GetMuBeta_detect_more_feature2(TrialData);
        elseif (f4FLag == 1)
            [Mu,Beta] = GetMuBeta_detect_more_feature3(TrialData);
        elseif (f5FLag == 1)
            [Mu,Beta] = GetMuBeta_detect_more_feature4(TrialData);
        elseif (f6FLag == 1)
            [Mu,Beta] = GetMuBeta_detect_more_feature5(TrialData);
        endif
        %else we've got preprojected already
    endif
        
    %default return
    TargetsLDA="Unknown";
    TargetsPCA="Unknown";

    ClassPCA = 0;
    ClassLDA = 0;

    % apply LDA method to the features
    if(LDAFLag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
        else
            Z = [Mu Beta]*real(VLDA);
        endif
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
            ClassLDA = 1;

        elseif(vote < 0)
            TargetsLDA = 'LEFT';
            ClassLDA = 2;
        else 
            single_target = ClassLabels( distance == min(distance(2:KLDA+1)));

            if(single_target > 0)
                TargetsLDA =  'RIGHT';
                ClassLDA = 1;
            else
                TargetsLDA = 'LEFT';
                ClassLDA = 2;
            end
        end
    endif
    
    if(PCAFlag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
        else
            Z = [Mu Beta]*real(VPCA);
        endif
        
        Z = Z(:,1:PC_NumPCA);
        %removed to fix mul dimensions
        %ZtrainPCA = ZtrainPCA';
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
            ClassPCA = 1;
        elseif(vote < 0)
            TargetsPCA = 'LEFT';
            ClassPCA = 2;
        else 
            single_target = ClassLabels( distance == min(distance(2:KPCA+1)));
            if(single_target > 0)
                TargetsPCA =  'RIGHT';
                ClassPCA = 1;
            else
                TargetsPCA = 'LEFT';
                ClassPCA = 2;
            end
        end
    endif
    %TODO check non of the CSP, LDA nor CSP flags raised 
    % Debug
	
    %DetectOut
    DetectOut.LDAresult = TargetsLDA;
    DetectOut.PCAresult = TargetsPCA;

    DetectOut.LDAResultClass = ClassLDA;
    DetectOut.PCAResultClass = ClassPCA;
end
