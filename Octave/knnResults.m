function [accuracy k_total] = knnResults(projected, ClassLabels)
    accuracy = [];
    projected = real(projected)';
    k_total = [];
    for n = 1:size(projected)(1)
        C1=[];
        C2=[];
        
        for k = 1:n
            C1 = [ C1 ; projected(k, :)(ClassLabels==1)];
            C2 = [ C2 ; projected(k, :)(ClassLabels==2)];
        end     
        t = [ones(size(C1)(2),1) ; -1*ones(size(C2)(2),1)];
        dataTotal = [C1,  C2]';
        k = KNNtrain(dataTotal, t);
        k_total = [k_total; k];
	acc = KNNtest (k, dataTotal, t, dataTotal, t);
    	accuracy = [accuracy , acc];
    end
end

