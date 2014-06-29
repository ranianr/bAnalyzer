function [DetectOut Debug] = Likelihood_Generic_Detect(DetectIn, directory, noiseFlag, idealFlag, butterFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,NoneFlag, preProjectedFlag)
   
 %{
 [DetectOut Debug] =Likelihood_Generic_Detect(1, 1,0,0,0,0,0,1,0,0,0);
 
 %}  
 	warning('off');
 	
    % Get inputs from python
    TrialData = DetectIn.("TrialData"); %data to be sent from python
    TrainOut = DetectIn.("TrainOut"); %

    VPCA = TrainOut.VPCA ;
    VLDA = TrainOut.VLDA ;
    V = TrainOut.V ;
    
    WPCA  = TrainOut.Wpca;
    WLDA  = TrainOut.Wlda;
    
    WoPCA  = TrainOut.Wopca;
    WoLDA  = TrainOut.Wolda;
    
	PC_NumPCA  = TrainOut.PC_NumPCA;
	PC_NumLDA  = TrainOut.PC_NumLDA;
        PC_Num  = TrainOut.PC_Num;
 
	mu1PCA = TrainOut.mu1PCA;
	mu2PCA = TrainOut.mu2PCA;
	mu1LDA = TrainOut.mu1LDA;
	mu2LDA = TrainOut.mu2LDA;
        mu1 = TrainOut.mu1;
	mu2 = TrainOut.mu2;

	PIPCA = TrainOut.PIPCA;
	PILDA = TrainOut.PILDA;
        PI = TrainOut.PI;

	segmaPCA = TrainOut.segmaPCA;
	segmaLDA = TrainOut.segmaLDA;
        segma = TrainOut.segma;

    %TODO according to the preprojectionflag, validate TrialData/VLDA/VPCA matrices
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
    Targets = "Unknown";

    ClassPCA = 0;
    ClassLDA = 0;
    Class = 0;

    % apply LDA method to the features
    if(LDAFLag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
            Z = Z(:,1:PC_NumLDA);  
        else
            Z = [Mu Beta]*real(VLDA(:,1:PC_NumLDA));
        endif
        %Z = Z(:,1:PC_NumLDA);       
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
            ClassLDA = 1;
        elseif(P_comparison == 0)
            TargetsLDA = 'LEFT';
            ClassLDA = 2;
        end
    endif
    if(NoneFlag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
            Z = Z(:,1:PC_Num);  
        else
            Z = [Mu Beta];
        endif
        Z = Z(:,1:PC_Num);       
        N1 = PI;
        N2 = 1-PI;
        P_comparison = [];
        
        for s = 1:size(Z)(1)
            P_XgivenC1_expTerm1 = -0.5*(Z(s,:)-mu1')*(inv(segma))*(Z(s,:)-mu1')' ;
            P_XgivenC2_expTerm2 = -0.5*(Z(s,:)-mu2')*(inv(segma))*(Z(s,:)-mu2')' ;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            P_comparison = [P_comparison; ModifiedClass1_Ratio > ModifiedClass2_Ratio];
	end
       
        if(P_comparison == 1)
            Targets = 'RIGHT';
            Class = 1;
        elseif(P_comparison == 0)
            Targets = 'LEFT';
            Class = 2;
        end
    endif
    
    if(PCAFlag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData';
        else
            Z = VPCA'*[Mu Beta]';
        endif
        Z = Z(1:PC_NumPCA,:);
        Z=Z';
        N1 = PIPCA;
        N2 = 1-PIPCA;
        P_comparison = [];
        %bug
        %for s = 1:size(Z)(1)
            P_XgivenC1_expTerm1 = -0.5*(Z-mu1PCA')*(inv(segmaPCA))*(Z-mu1PCA')' ;
            P_XgivenC2_expTerm2 = -0.5*(Z-mu2PCA')*(inv(segmaPCA))*(Z-mu2PCA')' ;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            P_comparison = [P_comparison; ModifiedClass1_Ratio > ModifiedClass2_Ratio];
        %end

        if(P_comparison == 1)
            TargetsPCA = 'RIGHT';
            ClassPCA = 1;
        elseif(P_comparison == 0)
            TargetsPCA = 'LEFT';
            ClassPCA = 2;
        end
    endif
    %TODO check non of the CSP, LDA nor CSP flags raised 
    % Debug
    DetectOut.vote = P_comparison;
    DetectOut.Z = Z;
    

    %DetectOut
    DetectOut.LDAresult = TargetsLDA;
    DetectOut.PCAresult = TargetsPCA;
    DetectOut.Noneresult = Targets;

    DetectOut.LDAResultClass = ClassLDA;
    DetectOut.PCAResultClass = ClassPCA;
    DetectOut.NoneResultClass = Class;
end
