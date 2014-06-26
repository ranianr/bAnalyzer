function [TrainOut ] = LEASTSQUARES_nClass_Train(directory, path="Classifiers/")
    % Add pathes of needed functions

    	
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
	%[Mu,Beta] = GetMuBeta(data, HDR);
        [Mu,Beta] = idealFilter_Train(data, HDR);

    % apply LDA method to the features
	X = [Mu Beta];
	%[Z, V] = LDA_fn(HDR.Classlabel, X, classes_no);
	[V, Z] = pcaProject(X); Z = Z';
	%Z=X;
	%V=1;

    % Get the classifier parameters here
        PC_Num = 2*14;
        ClassesData = zeros(size(X)(1)/nClass,PC_Num,nClass);
        W = zeros(nClass,PC_Num+1);

        for g = 1:nClass
            ClassesData(:,:,g)  = X(HDR.Classlabel == classes_no(g),:);
            temp                = X(HDR.Classlabel ~= classes_no(g),:);
            labels              = [ones(1,size(ClassesData(:,:,g))(1)) 2*ones(1,size(temp)(1))];
            W(g,:)              = Least_Classifier_Parameters(PC_Num, [ClassesData(:,:,g) ;temp], labels);
        end
    
    % Returing output structure
	TrainOut.V = V;
	TrainOut.W = W(:,1:end-1);
	TrainOut.Wo = W(:,end);
	TrainOut.PC_Num = PC_Num;
	TrainOut.HDR = HDR;
    TrainOut.Classnames = HDR.Classnames;
    TrainOut.nClass = nClass;
end
