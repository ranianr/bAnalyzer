function accuracy = likelihoodResults(projected, ClassLabels)
    accuracy = [];
    projected = real(projected)';
    for n = 1:size(projected)(1)
        C1=[];
        C2=[];
        
        for k = 1:n
            C1 = [ C1 ; projected(k, :)(ClassLabels == 1)];
            C2 = [ C2 ; projected(k, :)(ClassLabels == 2)];
        end     
        
        t = [ones(size(C1)(2),1) ; -1*ones(size(C2)(2),1)];
        dataTotal = [C1,  C2]';
        [PI, segma, mu1, mu2] = likelihood_train(dataTotal, t);
	acc = likelihood_test(PI, segma, mu1, mu2, dataTotal, t);
	accuracy = [accuracy, acc*100]; %accuracy of each section only
    end
end

