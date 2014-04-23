function KNN_LDA()
    %Load Raw Data Functions
        addpath("functions_rawdata");
        addpath("/home/raghda/Documents/GP/4Dclassifier");
    
    %Load Classifiers Functions
        addpath("functions_classification");
    
    %Get Raw Data
        filename = "data/[2014-01-15 16-13-49] Islam Maher.csv";
        %filename = "data/[2014-01-15 15-02-52] Mohamed Nour El-Din.csv";
        %filename = "data/[2014-01-15 16-59-17] Mohamed Salem.csv";
        %filename = "data/[2014-01-15 17-50-13] Walid Ezzat.csv";
        %filename = "data/[2014-01-15 18-24-13] Osama Mohamed.csv";
        %filename = "data/[2014-01-15 19-07-28] Abdullah Mahmoud.csv";
        %filename = "data/[2014-01-15 19-41-58] Ahmed Mohamed.csv";
        [Data, HDR] = getRawData(filename);
    
    %Channels Data (Ignoring Count, GyroX & GyroY)
        Data = Data(:,2:15);
    
    %Get Mu and Beta
        [Data_Mu, Data_Beta] = getMuBeta(Data,HDR);
    
    %Get Trials
        Trials_Mu   = getTrials(Data_Mu, HDR);
        Trials_Beta = getTrials(Data_Beta, HDR);
    
    	%Get Classes
        RIGHT_ClassNumber   = getClassNumber(HDR, "RIGHT");
        LEFT_ClassNumber    = getClassNumber(HDR, "LEFT");
       	ClassLabels = [RIGHT_ClassNumber; LEFT_ClassNumber];
    	c = HDR.Classlabel;
    	Xoriginal = [Trials_Mu , Trials_Beta];
    	%% LDA function calling
    	 C1 = Xoriginal(HDR.Classlabel==1,:);
         C2 = Xoriginal(HDR.Classlabel==2,:);
    	size(Xoriginal)
    	size(C1)
    	size(C2)
    	[Z, W] = CSP_fn(C1, C2);
      
    [V, Xm, Vproj]  = LDA_fn(c, Z, ClassLabels);
    size(V)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Applying LDA (Linear Discriminant Analysis)  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %then calculate the projection and reconstruction
        z1 = V(:,1);
        z2 = V(:,2);
        z3 = V(:,4);
    
    %2D Plot of PC1 & PC2
        figure(1);
        axis([-0.02 0.02 -0.02 0.02])
        plot(z1(HDR.Classlabel == RIGHT_ClassNumber),z2(HDR.Classlabel == RIGHT_ClassNumber),"ro", "markersize", 10, "linewidth", 3
             ,z1(HDR.Classlabel == LEFT_ClassNumber),z2(HDR.Classlabel == LEFT_ClassNumber),"bo", "markersize", 10, "linewidth", 3)
        title('2D Plot of PC1 & PC2');
    
    %3D Plot of PC1, PC2 & PC3
        figure(2);
        plot3(z1(HDR.Classlabel == RIGHT_ClassNumber), z2(HDR.Classlabel == RIGHT_ClassNumber), z3(HDR.Classlabel == RIGHT_ClassNumber),"ro", "markersize", 10, "linewidth", 3)
        hold on;
        plot3(z1(HDR.Classlabel == LEFT_ClassNumber), z2(HDR.Classlabel == LEFT_ClassNumber), z3(HDR.Classlabel == LEFT_ClassNumber),"bo", "markersize", 10, "linewidth", 3)
        title('3D Plot of PC1, PC2 & PC3');
        hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %%  Accuracy of LDA  %%
    %%%%%%%%%%%%%%%%%%%%%%%
        Z = V
        accuracy = getAccuracy(Z, HDR);
        size(V)
        figure(3);
        plot(accuracy);
        title('Accuracy of LDA -- KNN "headset data"');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Analysis of Channels (Which channel affects the data)  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure(4)
        size(Vproj)
        [PC1, idx] = sort(Vproj(:,1), 'descend')
 	size(idx)   
        size(PC1)
        
        PC1 = (Vproj(:,1))(idx)
        PC2 = (Vproj(:,2))(idx)
        
        BarLabels = [strcat(HDR.Label(2:15), "_M"); strcat(HDR.Label(2:15), "_B")];
        BarLabels = BarLabels(idx)
        
        bar([PC1, PC2]);
        set(gca, 'XTickLabel', BarLabels, 'XTick', 1:numel(BarLabels));
end

function accuracy = getAccuracy(projected, HDR)
    accuracy = [];
    projected = real(projected)';
    
    for n = 1:size(projected)(1)
        C1=[];
        C2=[];
        
        for k = 1:n
            C1 = [ C1 ; projected(k, :)(HDR.Classlabel==1)];
            C2 = [ C2 ; projected(k, :)(HDR.Classlabel==2)];
        end     
        t = [ones(size(C1)(2),1) ; -1*ones(size(C2)(2),1)];
        dataTotal = [C1,  C2]';
        k = KNNtrain(dataTotal, t)
	acc = KNNtest (k, dataTotal, t, dataTotal, t);
    	accuracy = [accuracy , acc];
    end
end

