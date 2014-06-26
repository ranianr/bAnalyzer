function [DetectOut Debug] = LEASTSQUARES_Detect(DetectIn, path="Classifiers/")
	
	% Get inputs from python
	TrainOut = DetectIn.("TrainOut");
	TrialData = DetectIn.("TrialData");
        
    V       = TrainOut.V;
    W       = TrainOut.W;
    Wo      = TrainOut.Wo;
	PC_Num  = TrainOut.PC_Num;
	
	% do pre-processing here please
	
	noise = mean(TrialData);
	TrialData = bsxfun(@minus, TrialData, noise);

	% Get features (mu & beta)
	[Mu,Beta]  = idealFilter(TrialData);

	%[Mu,Beta] = GetMuBeta_Test(TrialData',HDR);
	features = [Mu Beta];
	%features - features_test(1,:)
	 % apply LDA method to the features
%{
	%features_test = bsxfun(@minus, features_test, mean(features_test));
	Z_test = features_test*real(V(:,1:PC_Num));
    	% apply the classifier here
	w = [W Wo];
	t=HDR.Classlabel;
	t(t==2)=-1;
	accuracy = accuracy = classifyGetAccuracy(t,w,Z_test);
	disp(["the accuracy I wish is = " num2str(accuracy)]);

	%features = bsxfun(@minus, features, mean(features));
	%size_of_features_test_is = size(features_test )
%}
	Z = features(:,1:PC_Num);
	y = TrainOut.W'*Z';
	y += Wo;
    	% getting the class label here 
	Target = "NONE";
        if(y > 0) 
            Target = "RIGHT";
	elseif(y < 0)
            Target = "LEFT";
	end
    
    	% Debug
	Debug.W = W;
	Debug.pc = PC_Num;
    
    	%DetectOut
	DetectOut = Target;
end