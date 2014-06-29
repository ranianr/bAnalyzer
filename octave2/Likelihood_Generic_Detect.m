function [DetectOut Debug] = Likelihood_Generic_Detect(DetectIn,likelihoodClass, directory, noiseFlag, idealFlag, butterFlag, f1FLag,f2FLag,f3FLag,f4FLag,f5FLag,f6FLag,LDAFLag,PCAFlag,CSP_LDAFlag,NoneFlag, preProjectedFlag)
   
 %{
 [DetectOut Debug] =Likelihood_Generic_Detect(1, 1,0,0,0,0,0,1,0,0,0);
 
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
    %------
    VLDA           = TrainOut.VLDA;
    PC_NumLDA      = TrainOut.PC_NumLDA;
    %------
    VPCA           = TrainOut.VPCA;
    PC_NumPCA      = TrainOut.PC_NumPCA;
    %------
    V           = TrainOut.V;
    PC_Num      = TrainOut.PC_Num;
    %------
    nClass      = TrainOut.nClass;
    Classnames  = TrainOut.Classnames;
    
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
            Z = [Mu Beta];
        endif
        features = Z ; 
          Class_Ratio = [];
	%Z = features(:,1:PC_Num);
         for ClassNo = 1:nClass    
            Z = features*real(VLDA(:,1:PC_NumLDA(ClassNo)));
            if(ClassNo == 1)
              PI_c1 = TrainOut.PILDA.PI_c1;
              segma_c1 = TrainOut.SegmaLDA.segma_c1;
              mu1_c1 = TrainOut.mu1LDA.mu1_c1;
              mu2_c1 = TrainOut.mu2LDA.mu2_c1;
              N1 = PI_c1;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c1')*(inv(segma_c1))*(Z - mu1_c1')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c1')*(inv(segma_c1))*(Z - mu2_c1')' ;
            elseif(ClassNo == 2)
              PI_c2 = TrainOut.PILDA.PI_c2;
              segma_c2 = TrainOut.SegmaLDA.segma_c2;
              mu1_c2 = TrainOut.mu1LDA.mu1_c2;
              mu2_c2 = TrainOut.mu2LDA.mu2_c2;
              N1 = PI_c2;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c2')*(inv(segma_c2))*(Z - mu1_c2')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c2')*(inv(segma_c2))*(Z - mu2_c2')' ;
            elseif(ClassNo == 3)
              PI_c3 = TrainOut.PILDA.PI_c3;
              segma_c3 = TrainOut.SegmaLDA.segma_c3;
              mu1_c3 = TrainOut.mu1LDA.mu1_c3;
              mu2_c3 = TrainOut.mu2LDA.mu2_c3;
              N1 = PI_c3;    
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c3')*(inv(segma_c3))*(Z - mu1_c3')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c3')*(inv(segma_c3))*(Z - mu2_c3')' ;
            elseif(ClassNo == 4)
              PI_c4 = TrainOut.PILDA.PI_c4;
              segma_c4 = TrainOut.SegmaLDA.segma_c4;
              mu1_c4 = TrainOut.mu1LDA.mu1_c4;
              mu2_c4 = TrainOut.mu2LDA.mu2_c4;
              N1 = PI_c4;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c4')*(inv(segma_c4))*(Z - mu1_c4')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c4')*(inv(segma_c4))*(Z - mu2_c4')' ;
            elseif(ClassNo == 5)
              PI_c5 = TrainOut.PILDA.PI_c5;
              segma_c5 = TrainOut.SegmaLDA.segma_c5;
              mu1_c5 = TrainOut.mu1LDA.mu1_c5;
              mu2_c5 = TrainOut.mu2LDA.mu2_c5;
              N1 = PI_c5;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c5')*(inv(segma_c5))*(Z - mu1_c5')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c5')*(inv(segma_c5))*(Z - mu2_c5')' ;
            endif
            N2 = 1-N1;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            Class_Ratio = [Class_Ratio; ModifiedClass1_Ratio];
         end
           
 % getting the class label here
  	[maxYvalue maxPositiveClass] = max(Class_Ratio);
	TargetsLDA = Classnames(maxPositiveClass);
        for i=1:size(classes_no)(2)
            if(ismember(TargetsLDA{1,1}, Classes{i,1}))
                ClassLDA = i
            endif
        end

    endif
    if(NoneFlag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData;
            Z = Z(:,1:PC_Num);  
        else
            Z = [Mu Beta];
        endif
        features = Z ;
          Class_Ratio = [];
	%Z = features(:,1:PC_Num);
         for ClassNo = 1:nClass
             
           Z = features(:,1:PC_Num(ClassNo));
            x="hiiiiiiii"
            if(ClassNo == 1)
              PI_c1 = TrainOut.PI.PI_c1;
              segma_c1 = TrainOut.Segma.segma_c1;
              mu1_c1 = TrainOut.mu1.mu1_c1;
              mu2_c1 = TrainOut.mu2.mu2_c1;
              N1 = PI_c1;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c1')*(inv(segma_c1))*(Z - mu1_c1')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c1')*(inv(segma_c1))*(Z - mu2_c1')' ;
            elseif(ClassNo == 2)
              PI_c2 = TrainOut.PI.PI_c2;
              segma_c2 = TrainOut.Segma.segma_c2;
              mu1_c2 = TrainOut.mu1.mu1_c2;
              mu2_c2 = TrainOut.mu2.mu2_c2;
              N1 = PI_c2;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c2')*(inv(segma_c2))*(Z - mu1_c2')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c2')*(inv(segma_c2))*(Z - mu2_c2')' ;
            elseif(ClassNo == 3)
              PI_c3 = TrainOut.PI.PI_c3;
              segma_c3 = TrainOut.Segma.segma_c3;
              mu1_c3 = TrainOut.mu1.mu1_c3;
              mu2_c3 = TrainOut.mu2.mu2_c3;
              N1 = PI_c3;    
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c3')*(inv(segma_c3))*(Z - mu1_c3')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c3')*(inv(segma_c3))*(Z - mu2_c3')' ;
            elseif(ClassNo == 4)
              PI_c4 = TrainOut.PI.PI_c4;
              segma_c4 = TrainOut.Segma.segma_c4;
              mu1_c4 = TrainOut.mu1.mu1_c4;
              mu2_c4 = TrainOut.mu2.mu2_c4;
              N1 = PI_c4;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c4')*(inv(segma_c4))*(Z - mu1_c4')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c4')*(inv(segma_c4))*(Z - mu2_c4')' ;
            elseif(ClassNo == 5)
              PI_c5 = TrainOut.PI.PI_c5;
              segma_c5 = TrainOut.Segma.segma_c5;
              mu1_c5 = TrainOut.mu1.mu1_c5;
              mu2_c5 = TrainOut.mu2.mu2_c5;
              N1 = PI_c5;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c5')*(inv(segma_c5))*(Z - mu1_c5')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c5')*(inv(segma_c5))*(Z - mu2_c5')' ;
            endif
            N2 = 1-N1;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            Class_Ratio = [Class_Ratio; ModifiedClass1_Ratio];
         end
           
        % getting the class label here
  	[maxYvalue maxPositiveClass] = max(Class_Ratio);
	Targets = Classnames(maxPositiveClass);
        for i=1:size(classes_no)(2)
            if(ismember(Targets{1,1}, Classes{i,1}))
                Class = i
            endif
        end

    endif
    
    if(PCAFlag == 1)
        if (preProjectedFlag == 1)
            Z =TrialData';
        else
             Z = [Mu Beta];
        endif
        features = Z ; 
          Class_Ratio = [];
	%Z = features(:,1:PC_Num);
         for ClassNo = 1:nClass    
            Z = features*real(VPCA(:,1:PC_NumPCA(ClassNo)));
            x="hiiiiiiiii"
            if(ClassNo == 1)
              PI_c1 = TrainOut.PIPCA.PI_c1;
              segma_c1 = TrainOut.SegmaPCA.segma_c1;
              mu1_c1 = TrainOut.mu1PCA.mu1_c1;
              mu2_c1 = TrainOut.mu2PCA.mu2_c1;
              N1 = PI_c1;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c1')*(inv(segma_c1))*(Z - mu1_c1')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c1')*(inv(segma_c1))*(Z - mu2_c1')' ;
            elseif(ClassNo == 2)
              PI_c2 = TrainOut.PIPCA.PI_c2;
              segma_c2 = TrainOut.SegmaPCA.segma_c2;
              mu1_c2 = TrainOut.mu1PCA.mu1_c2;
              mu2_c2 = TrainOut.mu2PCA.mu2_c2;
              N1 = PI_c2;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c2')*(inv(segma_c2))*(Z - mu1_c2')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c2')*(inv(segma_c2))*(Z - mu2_c2')' ;
            elseif(ClassNo == 3)
              PI_c3 = TrainOut.PIPCA.PI_c3;
              segma_c3 = TrainOut.SegmaPCA.segma_c3;
              mu1_c3 = TrainOut.mu1PCA.mu1_c3;
              mu2_c3 = TrainOut.mu2PCA.mu2_c3;
              N1 = PI_c3;    
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c3')*(inv(segma_c3))*(Z - mu1_c3')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c3')*(inv(segma_c3))*(Z - mu2_c3')' ;
            elseif(ClassNo == 4)
              PI_c4 = TrainOut.PIPCA.PI_c4;
              segma_c4 = TrainOut.SegmaPCA.segma_c4;
              mu1_c4 = TrainOut.mu1PCA.mu1_c4;
              mu2_c4 = TrainOut.mu2PCA.mu2_c4;
              N1 = PI_c4;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c4')*(inv(segma_c4))*(Z - mu1_c4')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c4')*(inv(segma_c4))*(Z - mu2_c4')' ;
            elseif(ClassNo == 5)
              PI_c5 = TrainOut.PIPCA.PI_c5;
              segma_c5 = TrainOut.SegmaPCA.segma_c5;
              mu1_c5 = TrainOut.mu1PCA.mu1_c5;
              mu2_c5 = TrainOut.mu2PCA.mu2_c5;
              N1 = PI_c5;
              P_XgivenC1_expTerm1 = -0.5*(Z - mu1_c5')*(inv(segma_c5))*(Z - mu1_c5')' ;
              P_XgivenC2_expTerm2 = -0.5*(Z - mu2_c5')*(inv(segma_c5))*(Z - mu2_c5')' ;
            endif
            N2 = 1-N1;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            Class_Ratio = [Class_Ratio; ModifiedClass1_Ratio];
         end
           
 % getting the class label here
  	[maxYvalue maxPositiveClass] = max(Class_Ratio);
	TargetsPCA = Classnames(maxPositiveClass);
        for i=1:size(classes_no)(2)
            if(ismember(TargetsPCA{1,1}, Classes{i,1}))
                ClassPCA = i
            endif
        end
    endif
    %TODO check non of the CSP, LDA nor CSP flags raised 
    % Debug
    %DetectOut.vote = P_comparison;
    DetectOut.Z = Z;
    

    %DetectOut
    DetectOut.LDAresult = TargetsLDA;
    DetectOut.PCAresult = TargetsPCA;
    DetectOut.Noneresult = Targets;

    DetectOut.LDAResultClass = ClassLDA;
    DetectOut.PCAResultClass = ClassPCA;
    DetectOut.NoneResultClass = Class;
end
