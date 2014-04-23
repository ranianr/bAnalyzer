function accuracy = likelihoodResults(C1, C2, ClassLabels)
    accuracy = [];
   % projected = real(projected)';
    dataTotal = [C1;  C2];
    for n = 1:size(dataTotal)(2)
  	C1_try = C1(:,1:n);
  	C2_try = C2(:,1:n);
  	data = dataTotal(:,1:n);
        [PI, segma, mu1, mu2] = likelihood_train(C1_try, C2_try, ClassLabels');
	acc = likelihood_test(PI, segma, mu1, mu2, data, ClassLabels');
	accuracy = [accuracy, acc*100]; %accuracy of each section only
    end
end

