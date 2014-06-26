function [DetectOut Debug] = LEASTSQUARES_nClass_Detect(DetectIn, path="Classifiers/")
	
	% Get inputs from python
	TrainOut = DetectIn.("TrainOut");
	TrialData = DetectIn.("TrialData");
        
        V           = TrainOut.V;
        W           = TrainOut.W;
        Wo          = TrainOut.Wo;
	PC_Num      = TrainOut.PC_Num;
        nClass      = TrainOut.nClass;
        Classnames  = TrainOut.Classnames;

	
	% do pre-processing here please
	
	noise = mean(TrialData);
	TrialData = bsxfun(@minus, TrialData, noise);

	% Get features (mu & beta)

	[Mu,Beta]  = idealFilter(TrialData);

	%[Mu,Beta] = GetMuBeta_Test(TrialData',HDR);
	features = [Mu Beta];

	Z = features(:,1:PC_Num);
        y=zeros(1,nClass);
        for ClassNo = 1:nClass    
            y(ClassNo) = W(ClassNo,1:PC_Num)*Z' + Wo(ClassNo);
        end
    	% getting the class label here
        [maxYvalue maxPositiveClass] = max(y);
	Target = Classnames(maxPositiveClass);
    
    	% Debug
	Debug.W = W;
	Debug.pc = PC_Num;
    
    	%DetectOut
	DetectOut = Target{1};
end
