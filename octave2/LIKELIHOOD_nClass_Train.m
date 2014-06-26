function [TrainOut ] = LIKELIHOOD_nClass_Train(directory, path="Classifiers/")
    % Add pathes of needed functions
	addpath([path 'Functions']);
	addpath([path 'RawDataFunctions']);
    	
    % Get Raw Data from the file 
	[data, HDR] = getRawData(directory);
        HDR.TRIG = HDR.TRIG +1;
    % Intial values
        Classes = HDR.Classnames;
        nClass = length(Classes);
        classes_no =[];
        for g = 1:nClass
            classes_no = [ classes_no , getClassNumber(HDR,Classes(g)) ];
        end
    
    % do pre-processing here please 
	noise = mean(data')';
	data = bsxfun(@minus, data, noise);

    % Get features (mu & beta)
        [Mu,Beta] = idealFilter_Train(data, HDR);
    % apply LDA method to the features
	X = [Mu Beta];
	[Zo, V] = LDA_fn(HDR.Classlabel, X, classes_no);
    % Get the classifier parameters here
        PC_Num = [];
     
        for g = 1:nClass
            C1 = Zo((HDR.Classlabel == g),:);
            C2 = Zo((HDR.Classlabel ~= g),:);
            Z = [C1; C2];
            t = [ones(size(C1)(1),1) ; -1*ones(size(C2)(1),1)]';
            accuracy = likelihoodResults(C1, C2, t);
            [AccSelected, AccIndex] = max(accuracy);
            PC_Num =[PC_Num; min(AccIndex)];
            [PI segma mu1 mu2] = Likeli_Classifier_Parameters(PC_Num(g), Z, t);
            S.PI = PI;
            S.segma = segma;
            S.mu1 = mu1;
            S.mu2 = mu2;
            if(g == 1) Class = [S]; else Class = [Class S]; end
	end
    
    % Returing output structure
	TrainOut.Class = Class;	
	TrainOut.V = V;
	TrainOut.PC_Num = PC_Num;
	TrainOut.HDR = HDR;
	TrainOut.Classnames = HDR.Classnames;
	TrainOut.nClass = nClass;
end
