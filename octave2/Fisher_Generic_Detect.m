function [DetectOut Debug] = KNN_Generic_Detect(DetectIn, noiseFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,CSPFlag)
   
 %{
 [DetectOut Debug] = Fisher_Generic_Detect(1, 1,0,0,0,0,0,1,0,0,0);
 
 %}
    warning('off');
    %TESTING AND DEBUGGING
    [Data, HDR] = getRawData("./Osama Mohamed.csv");
    TRIG = HDR.TRIG(5);
    DetectIn.("TrialData") = getTrialData(Data, TRIG, 5, length(HDR.TRIG));

    %to test PCA flag use Fisher_Generic("../Osama Mohamed.csv",1,1,0,0,0,0,0,0,1,0,0,0,4 );
    %to test LDA flag use Fisher_Generic("../Osama Mohamed.csv",1,1,0,0,0,0,0,1,0,0,0,0,4 );
    %TODO change this behavior of debugging/testing :'/
    TrainOut = Fisher_Generic("./Osama Mohamed.csv",1,1,0,0,0,0,0,0,1,0,0,0,4 ); 
    DetectIn.("TrainOut") = TrainOut;

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
	PC_NumLDA  = TrainOut.PC_NumLDA;

    % do pre-processing here please
    if(noiseFlag == 1)
        testw
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
            y = TrainOut.Wlda'*Z';
            y += WoLDA;
    if(y > 0) 
        TargetsLDA = "RIGHT"
            elseif(y < 0)
        TargetsLDA = "LEFT"
            end
    endif

    if(PCAFlag == 1)
    	Z = [Mu Beta]*real(VPCA); 
        Z = Z(:,1:PC_NumPCA);
		y = TrainOut.Wpca'*Z';
		y += WoPCA;
        if(y > 0) 
            TargetsPCA = "RIGHT";
		elseif(y < 0)
            TargetsPCA = "LEFT";
		end
    endif
    %TODO check non of the CSP, LDA nor CSP flags raised 
    % Debug

    %DetectOut
	DetectOut.LDAresult = TargetsLDA;
	DetectOut.PCAresult = TargetsPCA;
end
