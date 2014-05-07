function [DetectOut Debug] = Likelihood_Generic_Detect(DetectIn, directory, noiseFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,CSPFlag, preProjectedFlag)
   
 %{
 [DetectOut Debug] =Likelihood_Generic_Detect(1, 1,0,0,0,0,0,1,0,0,0);
 
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
	PC_NumLDA  = TrainOut.PC_NumLDA;
 
	mu1PCA = TrainOut.mu1PCA;
	mu2PCA = TrainOut.mu2PCA;
	mu1LDA = TrainOut.mu1LDA;
	mu2LDA = TrainOut.mu2LDA;

	PIPCA = TrainOut.PIPCA;
	PILDA = TrainOut.PILDA;

	segmaPCA = TrainOut.segmaPCA;
	segmaLDA = TrainOut.segmaLDA;

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
    endif
	
    %default return
    TargetsLDA="Unknown";
    TargetsPCA="Unknown";
    % apply LDA method to the features
    if(LDAFLag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
        else
            Z = [Mu Beta]*real(VLDA);
        endif

        Z = Z(:,1:PC_NumLDA);
        N1 = PILDA;
        N2 = 1-PILDA;
        P_comparison = [];
        
        for s = 1:size(Z)(1)
            P_XgivenC1_expTerm1 = -0.5*(Z(s,:)-mu1LDA')*(inv(segmaLDA))*(Z(s,:)-mu1LDA')' ;
            P_XgivenC2_expTerm2 = -0.5*(Z(s,:)-mu2LDA')*(inv(segmaLDA))*(Z(s,:)-mu2LDA')' ;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            P_comparison = [P_comparison; ModifiedClass1_Ratio > ModifiedClass2_Ratio];
        end

        if(P_comparison == 1)
            TargetsLDA = 'RIGHT';
        elseif(P_comparison == 0)
            TargetsLDA = 'LEFT';
        end
    endif
    
    if(PCAFlag == 1)
        if (preProjectedFlag == 0)
            Z =TrialData;
        else
            Z = [Mu Beta]*real(VPCA);
        endif
        Z = Z(:,1:PC_NumPCA);
        N1 = PIPCA;
        N2 = 1-PIPCA;
        P_comparison = [];
        
        for s = 1:size(Z)(1)
            P_XgivenC1_expTerm1 = -0.5*(Z(s,:)-mu1PCA')*(inv(segmaPCA))*(Z(s,:)-mu1PCA')' ;
            P_XgivenC2_expTerm2 = -0.5*(Z(s,:)-mu2PCA')*(inv(segmaPCA))*(Z(s,:)-mu2PCA')' ;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            P_comparison = [P_comparison; ModifiedClass1_Ratio > ModifiedClass2_Ratio];
        end

        if(P_comparison == 1)
            TargetsPCA = 'RIGHT';
        elseif(P_comparison == 0)
            TargetsPCA = 'LEFT';
        end
    endif
    %TODO check non of the CSP, LDA nor CSP flags raised 
    % Debug
	

    %DetectOut
	DetectOut.LDAresult = TargetsLDA;
	DetectOut.PCAresult = TargetsPCA;
end
