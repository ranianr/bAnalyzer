function [PI, segma, mu1, mu2] = likelihood_train(c1, c2, target)
	%c1 = data(target == 1,:) ; %points of class 1
	%c2 = data(target == -1,:); %points of class 2
    %Get number of samples
    N1 = size(c1)(1);
    N2 = size(c2)(1);
    N = N1 + N2;
    %Get Pi
    PI = N1 / N;
    
    %Get mean
    mu1 = mean(c1)';
    mu2 = mean(c2)';
    
    %Get sigma
    S1 = getSum(c1, mu1)/N1;
    S2 = getSum(c2, mu2)/N2;
    segma = S1*(N1/N) + S2*(N2/N);
end

function s = getSum(c, m)
    s = 0;

    for k = 1:1:size(c)(1)
       Xn = c(k, :)';
       s = s + (Xn-m)*(Xn-m)';
    end
end
