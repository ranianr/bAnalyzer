%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Note : this is an optimized equations derived from 		%%
%% probability equations "liklihood classification method" 	%%
%% "P_XgivenC1_expTerm1 & P_XgivenC2_expTerm2" ... 		%%
%% "ModifiedClass1_Ratio" & "ModifiedClass2_Ratio"		%%
%% are desicion making of classes "P_comparison"		%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function accuracy = likelihood_test(PI, segma, mu1, mu2, x, t)
    %Get probabilties
    N1 = PI;
    N2 = 1-PI;
    P_comparison = [];
    for s = 1:size(x)(1)
	    P_XgivenC1_expTerm1 = -0.5*(x(s,:)-mu1')*(inv(segma))*(x(s,:)-mu1')' ;
	    P_XgivenC2_expTerm2 = -0.5*(x(s,:)-mu2')*(inv(segma))*(x(s,:)-mu2')' ;
	    ModifiedClass1_Ratio = log(N1/N2) + (P_XgivenC1_expTerm1 - P_XgivenC2_expTerm2);
	    ModifiedClass2_Ratio = log(N2/N1) + (P_XgivenC2_expTerm2 - P_XgivenC1_expTerm1); 
	    P_comparison = [P_comparison; ModifiedClass1_Ratio > ModifiedClass2_Ratio];
    end
    P_comparison(find(P_comparison == 0)) = -1;
    classify = P_comparison; %finally estimated targets
    class_diff = ((t - classify) == 0);
    accuracy = sum(class_diff)/length(classify);
end
