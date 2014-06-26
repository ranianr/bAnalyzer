function [DetectOut Debug] = LIKELIHOOD_nClass_Detect(DetectIn, path="Classifiers/")
	
	% Get inputs from python
        TrainOut = DetectIn.("TrainOut");
        TrialData = DetectIn.("TrialData");
              
        V           = TrainOut.V;
        PC_Num      = TrainOut.PC_Num;
        nClass      = TrainOut.nClass;
        Classnames  = TrainOut.Classnames;
	
	% do pre-processing here please
	
	noise = mean(TrialData);
	TrialData = bsxfun(@minus, TrialData, noise);

	% Get features (mu & beta)

	[Mu,Beta]  = idealFilter(TrialData);
	features = [Mu Beta];
	Class_Ratio = [];
	Class = {};
         for ClassNo = 1:nClass    
            Z = features*real(V(:,1:PC_Num(ClassNo)));
            ClassStruct = TrainOut.Class(ClassNo);
            PI = ClassStruct.PI;
            segma = ClassStruct.segma;
            mu1 = ClassStruct.mu1;
            mu2 = ClassStruct.mu2;
            N1 = PI;
            P_XgivenC1_expTerm1 = -0.5*(Z - mu1')*(inv(segma))*(Z - mu1')' ;
            P_XgivenC2_expTerm2 = -0.5*(Z - mu2')*(inv(segma))*(Z - mu2')' ;
            N2 = 1-PI;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            Class_Ratio = [Class_Ratio; ModifiedClass1_Ratio];
         end
           
 	% getting the class label here
	[maxYvalue maxPositiveClass] = max(Class_Ratio)
	Target = Classnames(maxPositiveClass);
    
    	% Debug
	Debug.pc = PC_Num;
 
    	%DetectOut
	DetectOut = Target{1};
end
