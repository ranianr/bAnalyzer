function ClassifierTest()
    addpath([path 'RawDataFunctions']);
    warning('off')
    %filename = "/home/raghda/Documents/GP/4Dclassifier/DetectorGUI/TrainingData/[2014-01-15 16-13-49] Islam Maher.csv";
    filename = "/home/raghda/Documents/GP/[2014-03-23]Braingizer/Data/TrainingData/Session_2014_05_10_71828/[T][2014-05-10 20-01-56] Osama Mohamed.csv";
    TrainOut =  LIKELIHOOD_nClasses_Train(filename, "");
    DetectIn.("TrainOut") = TrainOut;
    
    [Data, HDR] = getRawData(filename);
    
    %loop over data
    
    printMatrix = [];
    %for h = 1:28
        accuracy = 0;
%        DetectIn.("TrainOut").PC_Num = 3;
	result = [];
        
        for n = 1:length(HDR.TRIG)
            TRIG = HDR.TRIG(n);
            %DetectIn.("TrainOut").templabel =  TrainOut.ClassLabels(n);
            DetectIn.("TrialData") = getTrialData(Data, TRIG, n, length(HDR.TRIG));
            
            [DetectOut Debug] =  LIKELIHOOD_nClass_Detect(DetectIn, "");
            result = [result getClassNumber(HDR, DetectOut)];
            if(getClassNumber(HDR, DetectOut) == HDR.Classlabel(n))
                accuracy+=1;
            end
        end
        accuracy = accuracy/(length(HDR.TRIG));
	disp(accuracy)
end

function TrialData = getTrialData(Data, TRIG, TrigIndx,trigLength)
    trial_start = TRIG;
    if(TrigIndx == trigLength)
	TrialData = Data(TRIG : end,:)'; 
    else
	trial_end = TRIG + 4*128 -1;
	TrialData = Data(trial_start:trial_end,:)';
    end
end


%PROBLEM OF KNN: is that 
%%	We use k of PC 28 obtained from KNN_Train and here we use the same 
%%	k with all PCs that originally in KNN_Train has different value for 
%%	each PC.. So when we check KNN_Train accuracy for PC_Num = 28
%%	we'll find that it equals to 49% but here in detecting the 
%%	"PC_Num = 28" accuracy is the same and there's another 
%%	problem with k too.


