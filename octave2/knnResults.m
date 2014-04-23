function [accuracy k_total] = knnResults(projected, ClassLabels)
    accuracy = [];
    projected = real(projected)';
    k_total = [];
    C1 = [ projected(:,(ClassLabels==1))];
    C2 = [ projected(:,(ClassLabels==2))];
    t = [ones(size(C1)(2),1) ; -1*ones(size(C2)(2),1)];
   
    for n = 1:size(projected)(1)
        dataTotal = [C1(1:n,:),  C2(1:n,:)]';
        k = KNNtrain(dataTotal, t);
        k_total = [k_total; k];
	acc = KNNtest (k, dataTotal, t, dataTotal, t);
    	accuracy = [accuracy , acc];
    end
end

