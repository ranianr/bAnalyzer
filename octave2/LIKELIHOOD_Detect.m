function [DetectOut Debug] = LIKELIHOOD_Detect(DetectIn, path="Classifiers/")
    % Get inputs from python
	TrialData = DetectIn.("TrialData");
	TrainOut = DetectIn.("TrainOut");
        
  PI = TrainOut.PI;
	segma = TrainOut.Segma;
	mu1 = TrainOut.mu1;
	mu2 = TrainOut.mu2;
	V = TrainOut.V;
	PC_Num = TrainOut.PC_Num;
    
    % Add pathes of needed functions
	addpath([path 'Functions']);
	addpath([path 'RawDataFunctions']);
	%addpath([path 'wavelet']);

    % do pre-processing here please
	noise = mean(TrialData);
	TrialData = bsxfun(@minus, TrialData, noise);
%%	TrialData = [TrialData; noise];
    % Get features (mu & beta)
	[Mu, Beta] = waveletFeature(TrialData); %%%%%%%%%%%%%%%%%%%%%%%%%%%
	features = [Mu Beta];

    % apply LDA method to the features
	%Z = features(:,1:PC_Num);
	Z = features*real(V(:,1:PC_Num));
    % apply the classifier here
	N1 = PI;
	N2 = 1-PI;
	P_comparison = [];
            P_XgivenC1_expTerm1 = -0.5*(Z - mu1')*(inv(segma))*(Z - mu1')' ;
            P_XgivenC2_expTerm2 = -0.5*(Z - mu2')*(inv(segma))*(Z - mu2')' ;
            ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
            ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
            P_comparison = [P_comparison; ModifiedClass1_Ratio > ModifiedClass2_Ratio];
	
	if(P_comparison == 1)
            Target = 'RIGHT';
	elseif(P_comparison == 0)
            Target = 'LEFT';
	end
    
    % Debug
	Debug = P_comparison;
    
    %DetectOut
	DetectOut = Target;
end
