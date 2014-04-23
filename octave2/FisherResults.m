function [accuracy, W_Temp, Wo_Temp] = FisherResults(projected, ClassLabels)
    accuracy = [];
    projected = real(projected)';
    W_Temp = [];
    Wo_Temp = [];
    
    C1 = [projected(:,(ClassLabels==1))];
    C2 = [projected(:,(ClassLabels==2))];
for n = 1:size(projected)(1)
	t = [ones(size(C1)(2),1) ; -1*ones(size(C2)(2),1)];
 	dataTotal = [C1(1:n,:),  C2(1:n,:)];
	[W Wo]= fisherTrain(dataTotal', t);
	W = [W; Wo]';
	accuracy = [accuracy; classifyGetAccuracy(t, W, dataTotal')]; 
	
    end
end

