function [PI segma mu1 mu2] = Likeli_Classifier_Parameters(PC_Num, projected, targets)
    projected = real(projected)';
        C1=[];
        C2=[];
        C1 = projected(1:PC_Num,(targets==1));
        C2 = projected(1:PC_Num,(targets==-1));
        t = [ones(size(C1)(2),1)' , -1*ones(size(C2)(2),1)'];
        dataTotal = [C1,  C2]';
        [PI, segma, mu1, mu2] = likelihood_train(C1', C2', t');

end

