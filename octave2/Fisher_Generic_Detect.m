function [DetectOut Debug] = Fisher_Generic_Detect(DetectIn, directory, noiseFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFlag,PCAFlag,CSP_LDAFlag,CSPFlag, preProjectedFlag)
   
 %{
 [DetectOut Debug] = Fisher_Generic_Detect(1, 1,0,0,0,0,0,1,0,0,0);
 
 %}
    
    warning('off');

% Get inputs from python
    TrialData = DetectIn.("TrialData"); %data to be sent from python
    TrainOut = DetectIn.("TrainOut"); %

    VPCA = TrainOut.VPCA ;
    VLDA = TrainOut.VLDA ;
	
    WPCA  = TrainOut.Wpca;
    WLDA  = TrainOut.Wlda;
    
    WoPCA  = TrainOut.Wopca;
    WoLDA  = TrainOut.Wolda;
    
    PC_NumPCA  = TrainOut.PC_NumPCA;
    PC_NumLDA  = TrainOut.PC_NumLDA
    

    if (preProjectedFlag == 0)
        % do pre-processing here please
        if(noiseFlag == 1)
            noise = mean(TrialData')';
	TrialData =  TrialData -noise;
        endif

        % Get features (mu & beta) according to the selected method
        if(f1FLag == 1)
            [Mu,Beta] = GetMuBeta_detect(TrialData);
        elseif (f2FLag == 1)
            [Mu,Beta] = GetMuBeta_detect_more_feature(TrialData);
        elseif (f3FLag == 1)
            [Mu,Beta] = GetMuBeta_detect_more_feature2(TrialData);
        elseif (f4FLag == 1)
            [Mu,Beta] = GetMuBeta_detect_more_feature3(TrialData);
        elseif (f5FLag == 1)
            [Mu,Beta] = GetMuBeta_detect_more_feature4(TrialData);
        elseif (f6FLag == 1)
            [Mu,Beta] = GetMuBeta_detect_more_feature5(TrialData);
        endif
        %else the trial is already pre-projected
    endif
    
    %default return
    TargetsLDA="Unknown";
    TargetsPCA="Unknown";

    ClassPCA = 0;
    ClassLDA = 0;

    % apply LDA method to the features
    if(LDAFlag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
            Z = Z(:,1:PC_NumLDA);
        else
            Z = [Mu Beta]*real(VLDA);
        endif
        TrialData
        size(TrialData)
        %Mu
        %Beta
        %VLDA
        size(Z)
        Z
        %bug
        Z = Z(:,1:PC_NumLDA);
        
        y = TrainOut.Wlda'*Z;
        y += WoLDA;
        if(y > 0)
            TargetsLDA = "RIGHT";
            ClassLDA = 1;
        elseif(y < 0)
            TargetsLDA = "LEFT";
            ClassLDA = 2;
        end
    endif

    if(PCAFlag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData';
        else
            Z = VPCA'*[Mu Beta]';
        endif
       
        Z = Z(1:PC_NumPCA,:);
       
	y = TrainOut.Wpca'*Z;
	y += WoPCA;
        if(y > 0) 
            TargetsPCA = "RIGHT";
            ClassPCA = 1;
	elseif(y < 0)
            TargetsPCA = "LEFT";
            ClassPCA = 2;
	end
    endif
    %TODO check non of the CSP, LDA nor CSP flags raised 
    % Debug
    DetectOut.Z = Z;
    %DetectOut
    DetectOut.LDAresult = TargetsLDA;
    DetectOut.PCAresult = TargetsPCA;

    DetectOut.LDAResultClass = ClassLDA;
    DetectOut.PCAResultClass = ClassPCA;
end
