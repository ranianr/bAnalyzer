function [DetectOut Debug] = Leastsquares_Generic_Detect(DetectIn, directory, noiseFlag, idealFlag, butterFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,NoneFlag, preProjectedFlag)
   
 %{
 [DetectOut Debug] = Leastsquares_Generic_Detect(1, 1,0,0,0,0,0,1,0,0,0);
 
 %}  
    warning('off');
    
    % Get inputs from python
    TrialData = DetectIn.("TrialData"); %data to be sent from python
    TrainOut = DetectIn.("TrainOut"); %
    
    [data, HDR] = getRawData(directory);
    Classes = HDR.Classnames;
    nClass = length(Classes);
    classes_no =[];
    for g = 1:nClass
        classes_no = [ classes_no , getClassNumber(HDR,Classes(g)) ];
    end
    
    VPCA = TrainOut.VPCA ;
    VLDA = TrainOut.VLDA ;
	
    WPCA  = TrainOut.Wpca;
    WLDA  = TrainOut.Wlda;
    
    WoPCA  = TrainOut.Wopca;
    WoLDA  = TrainOut.Wolda;
    
    PC_NumPCA  = TrainOut.PC_NumPCA;
    PC_NumLDA  = TrainOut.PC_NumLDA;
    
    V           = TrainOut.V;
    W           = TrainOut.W;
    Wo          = TrainOut.Wo;
    PC_Num      = TrainOut.PC_Num;
    nClass      = TrainOut.nClass;
    Classnames  = TrainOut.Classnames;

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
    Target="Unknown";

    ClassPCA = 0;
    ClassLDA = 0;
    ClassNone = 0;

    % apply LDA method to the features
    if(LDAFLag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
        else
            Z = [Mu Beta]*real(VLDA);
        endif
        Z = Z(:,1:PC_NumLDA);
        y=zeros(1,nClass);
        for ClassNo = 1:nClass
            y(ClassNo) = WLDA(ClassNo,1:PC_NumLDA)*Z' + WoLDA(ClassNo);
        end
        
    	% getting the class label here
        [maxYvalue maxPositiveClass] = max(y);
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
            Z = VPCA'*[Mu Beta]';
        endif
        Z = Z(1:PC_NumPCA,:);
	y=zeros(1,nClass);
        for ClassNo = 1:nClass
            y(ClassNo) = WPCA(ClassNo,1:PC_NumPCA)*Z + WoPCA(ClassNo);
        end
        
    	% getting the class label here
        [maxYvalue maxPositiveClass] = max(y);
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
        else
            Z = [Mu Beta];
        endif
        Z = Z(:,1:PC_Num);
	y=zeros(1,nClass);
        for ClassNo = 1:nClass    
            y(ClassNo) = W(ClassNo,1:PC_Num)*Z' + Wo(ClassNo);
        end
    	% getting the class label here
        [maxYvalue maxPositiveClass] = max(y);
	Target = Classnames(maxPositiveClass);
        for i=1:size(classes_no)(2)
            if(ismember(Target{1,1}, Classes{i,1}))
                ClassNone = i
            endif
        end
        
    endif
    %TODO check non of the CSP, LDA nor CSP flags raised 
    % Debug
	

    %DetectOut
    DetectOut.NoneResult = Target;
    DetectOut.NoneResultClass = ClassNone;
    
    DetectOut.LDAresult = TargetsLDA;
    DetectOut.PCAresult = TargetsPCA;

    DetectOut.LDAResultClass = ClassLDA;
    DetectOut.PCAResultClass = ClassPCA;
end
