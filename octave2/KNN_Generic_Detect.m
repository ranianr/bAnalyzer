function DetectOut = KNN_Generic_Detect(DetectIn, directory, noiseFlag, idealFlag, butterFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,NoneFlag, preProjectedFlag)
   
 %{
 [DetectOut Debug] = KNN_Generic_Detect(1, 1,0,0,0,0,0,0,1,0,0);
 
 %}
 	%warning('off');
        %may be useful later
 	%[Data, HDR] = getRawData(directory);
    % Get inputs from python
    TrialData = DetectIn.("TrialData"); %data to be sent from python
    TrainOut = DetectIn.("TrainOut"); %
    %-----------
    [data, HDR] = getRawData(directory);
    Classes = HDR.Classnames;
    nClass = length(Classes);
    classes_no =[];
    for g = 1:nClass
        classes_no = [ classes_no , getClassNumber(HDR,Classes(g)) ];
    end
    %-----------
    VLDA           = TrainOut.VLDA;
    kTotalLDA      = TrainOut.kLDA;
    ZtrainLDA      = TrainOut.ZtrainLDA;
    PC_NumLDA      = TrainOut.PC_NumLDA;
    %-----------
    VPCA           = TrainOut.VPCA;
    kTotalPCA      = TrainOut.kPCA;
    ZtrainPCA      = TrainOut.ZtrainPCA;
    PC_NumPCA      = TrainOut.PC_NumPCA;
    %-----------
    VNone           = TrainOut.VNone;
    kTotalNone      = TrainOut.kNone;
    ZtrainNone      = TrainOut.ZtrainNone;
    PC_NumNone     = TrainOut.PC_NumNone;
    %-----------
    nClass      = TrainOut.nClass;
    Classlabel  = TrainOut.Classlabel;
    Classnames  = TrainOut.Classnames;
    classes_no = TrainOut.classes_no;
    
    

     if (preProjectedFlag == 0)

        % do pre-processing here please
        if(noiseFlag == 1)
            noise = mean(TrialData);
            TrialData = bsxfun(@minus, TrialData, noise);
            
        endif
        
        if(idealFlag == 1)
            if(f1FLag == 1)
                [Mu,Beta] = idealFilter(TrialData);
            elseif(f2FLag == 1)
                [Mu,temp] = idealFilter(TrialData, @min);
                [temp,Beta] = idealFilter(TrialData, @max);
            %TODO: support F3 to F6 flags
            endif
        endif
        if(butterFlag == 1)
            % Get features (mu & beta) according to the selected method
            if(f1FLag == 1)
                [Mu,Beta] =  GetMuBeta_detect(TrialData);
            elseif (f2FLag == 1)
                [Mu,Beta] =  GetMuBeta_detect_more_feature(TrialData);
            elseif (f3FLag == 1)
                [Mu,Beta] =  GetMuBeta_detect_more_feature2(TrialData);
            elseif (f4FLag == 1)
                [Mu,Beta] =  GetMuBeta_detect_more_feature3(TrialData);
            elseif (f5FLag == 1)
                [Mu,Beta] =  GetMuBeta_detect_more_feature4(TrialData);
            elseif (f6FLag == 1)
                [Mu,Beta] = GetMuBeta_detect_more_feature5(TrialData);
            endif
        endif
        %else we've got preprojected data
    endif
	
        
    %default return
    TargetsLDA="Unknown";
    TargetsPCA="Unknown";
    Targets="Unknown";
    ClassPCA = 0;
    ClassLDA = 0;
    Class=0;

    % apply LDA method to the features
    if(LDAFLag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
            Z = Z(:,1:PC_NumLDA);
        else

            Z = [Mu Beta];
        endif
        
        features = Z ; 
        Votes = [];
	   
         for ClassNo = 1:nClass  
            Z = features*real(VLDA(:,1:PC_NumLDA(ClassNo)));
            ZtrainTemp = ZtrainLDA(:,1:PC_NumLDA(ClassNo));
            C1  = ZtrainTemp(Classlabel == classes_no(ClassNo),:);
            C2  = ZtrainTemp(Classlabel ~= classes_no(ClassNo),:);
	    ZtrainTemp = [C1; C2];
            ClassLabels = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
            k = kTotalLDA(ClassNo);
        	if(size(Z)(2) == 1)
			ZtrainTemp = [ZtrainTemp, ZtrainTemp];
			Z = [Z, Z];
          end
	
            pointDistance = distancePoints(Z, ZtrainTemp);
            distance = pointDistance';
            [dist index1] = sort(distance);
            nearestK = dist(2:k+1);
            nearestPointsIndex = index1(2:k+1);
            Ktargets = ClassLabels(nearestPointsIndex);
            vote = sum(Ktargets);
            Yp = 0;%add else error = error +1
            
            if (vote == 0 ) 
                single_target = ClassLabels( distance == min(distance(2:k+1)));
                Votes = [Votes; single_target];
            else
                Votes = [Votes; vote];
            end
            end
        
            % getting the class label here
            [maxYvalue maxPositiveClass] = max(Votes)
            TargetsLDA = Classnames(maxPositiveClass);
            for i=1:size(classes_no)(2)
                if(ismember(TargetsLDA{1,1}, Classes{i,1}))
                    ClassLDA = i
                endif
            end
    endif
    
    if(PCAFlag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData';
        else
            Z =[Mu Beta];
        endif
         
        features = Z ; 
        Votes = [];
	   
         for ClassNo = 1:nClass
             x = "hiiii"
            Z = features*real(VPCA(:,1:PC_NumPCA(ClassNo)));
            x = "hiiii"
            ZtrainTemp = ZtrainPCA(:,1:PC_NumPCA(ClassNo));
            C1  = ZtrainTemp(Classlabel == classes_no(ClassNo),:);
            C2  = ZtrainTemp(Classlabel ~= classes_no(ClassNo),:);
	    ZtrainTemp = [C1; C2];
            ClassLabels = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
            k = kTotalPCA(ClassNo);
        	if(size(Z)(2) == 1)
			ZtrainTemp = [ZtrainTemp, ZtrainTemp];
			Z = [Z, Z];
          end
	
            pointDistance = distancePoints(Z, ZtrainTemp);
            distance = pointDistance';
            [dist index1] = sort(distance);
            nearestK = dist(2:k+1);
            nearestPointsIndex = index1(2:k+1);
            Ktargets = ClassLabels(nearestPointsIndex);
            vote = sum(Ktargets);
            Yp = 0;%add else error = error +1
            
            if (vote == 0 ) 
                single_target = ClassLabels( distance == min(distance(2:k+1)));
                Votes = [Votes; single_target];
            else
                Votes = [Votes; vote];
            end
            end
        
            % getting the class label here
            [maxYvalue maxPositiveClass] = max(Votes)
            TargetsPCA = Classnames(maxPositiveClass);
            for i=1:size(classes_no)(2)
                if(ismember(TargetsPCA{1,1}, Classes{i,1}))
                    ClassPCA = i
                endif
            end
    endif
    
    if(NoneFlag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
            Z = Z(:,1:PC_NumNone);
        else
            Z = [Mu Beta];
        endif
        
        features = Z ; 
        Votes = [];
         for ClassNo = 1:nClass
            x = "begin"
            Z = features(:,1:PC_NumNone(ClassNo))
            size(Z)
            x = "hiiiii"
            ZtrainTemp = ZtrainNone(:,1:PC_NumNone(ClassNo));
            x = "hiiiii"
            C1  = ZtrainTemp(Classlabel == classes_no(ClassNo),:);
            C2  = ZtrainTemp(Classlabel ~= classes_no(ClassNo),:);
            x = "hiiiii"
	    ZtrainTemp = [C1; C2];
            x = "hiiiiiiiiiiii"
            ClassLabels = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
            k = kTotalNone(ClassNo);
            if(size(Z)(2) == 1)
                ZtrainTemp = [ZtrainTemp, ZtrainTemp];
    		Z = [Z, Z];
                size(Z)
            end
	    x = "hiiiiiiiiiiii"
            size(ZtrainTemp)
            size(Z)
            pointDistance = distancePoints(Z, ZtrainTemp)
            distance = pointDistance';
            [dist index1] = sort(distance);
	    x = "hiiiiiiiiiiii"

            nearestK = dist(2:k+1);
            nearestPointsIndex = index1(2:k+1);
            Ktargets = ClassLabels(nearestPointsIndex);
            vote = sum(Ktargets);
            Yp = 0;%add else error = error +1
	    x = "hiiiiiiiiiiii"
            
            if (vote == 0 ) 
                single_target = ClassLabels( distance == min(distance(2:k+1)));
                Votes = [Votes; single_target];
            else
                Votes = [Votes; vote];
            end
            end
        
            % getting the class label here
            [maxYvalue maxPositiveClass] = max(Votes)
            x = "hiiiii"
            Targets = Classnames(maxPositiveClass);
            x = "hiiiii"
            for i=1:size(classes_no)(2)
                if(ismember(Targets{1,1}, Classes{i,1}))
                    Class = i
                endif
            end
            x = "hiiiii"
    endif
    %TODO check non of the CSP, LDA nor CSP flags raised 
    % Debug
    DetectOut.Z = Z;
    %DetectOut
    DetectOut.LDAresult = TargetsLDA;
    DetectOut.Noneresult = Targets
    DetectOut.PCAresult = TargetsPCA;

    DetectOut.LDAResultClass = ClassLDA;
    DetectOut.NoneResultClass = Class;
    DetectOut.PCAResultClass = ClassPCA;
end
