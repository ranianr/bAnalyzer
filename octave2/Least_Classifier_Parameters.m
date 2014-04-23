function W  = Least_Classifier_Parameters(PC_Num, projected, ClassLabels)
    projected = real(projected)';
    for n = 1:PC_Num
        C1=[];
        C2=[];
        
        for k = 1:n
            C1 = [ C1 ; projected(k, :)(ClassLabels==1)];
            C2 = [ C2 ; projected(k, :)(ClassLabels==2)];
        end
        
        [W, t, x] = leastSquaresTrain(C1' ,C2');
    end
end
