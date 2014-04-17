function [accuracy, W_Temp, Wo_Temp] = FisherResults(projected, ClassLabels)
    accuracy = [];
    projected = real(projected)';
    W_Temp = [];
    Wo_Temp = [];
    for n = 1:size(projected)(1)
        C1=[];
        C2=[];
       
        for k = 1:n
            C1 = [ C1 ; projected(k, :)(ClassLabels==1)];
            C2 = [ C2 ; projected(k, :)(ClassLabels==2)];
        end     
        t = [ones(size(C1)(2),1) ; -1*ones(size(C2)(2),1)];
 	dataTotal = [C1,  C2]';
     
	[W Wo]= fisherTrain(dataTotal, t);
	W_Temp = [W_Temp; W];
	Wo_Temp = [Wo_Temp; Wo];
	acc =  fisherTest(dataTotal, t, W, Wo);
	accuracy = [accuracy; acc]; 
	
    end
end

