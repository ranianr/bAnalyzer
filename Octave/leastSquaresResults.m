function accuracy = leastSquaresResults(projected, ClassLabels)
    accuracy = [];
    projected = real(projected)';
    for n = 1:size(projected)(1)
        C1=[];
        C2=[];
        
        for k = 1:n
            C1 = [ C1 ; projected(k, :)(ClassLabels==1)];
            C2 = [ C2 ; projected(k, :)(ClassLabels==2)];
        end
        
        [w, t, x] = leastSquaresTrain(C1' ,C2');
        accuracy = [accuracy ; classifyGetAccuracy(t,w,x)];
    end
end
