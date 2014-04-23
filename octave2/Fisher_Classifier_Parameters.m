function [W, Wo] = Fisher_Classifier_Parameters(PC_Num, projected, ClassLabels)

    projected = real(projected)';
    for n = 1:size(projected)(1)
        C1=[];
        C2=[];
        for k = 1:PC_Num
            C1 = [ C1 ; projected(k, :)(ClassLabels==1)];
            C2 = [ C2 ; projected(k, :)(ClassLabels==2)];
        end     
        t = [ones(size(C1)(2),1) ; -1*ones(size(C2)(2),1)];
 	dataTotal = [C1,  C2]';
	[W Wo]= fisherTrain(dataTotal, t);
    end
end
