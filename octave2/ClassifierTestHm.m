function ClassifierTestHm()    
#sh3'al m3 el N like - least
warning("off")
    filename = "/home/rho/Documents/GP/bAnalyzer/master/Data/Training/OldData/[T][2014-01-15 15-02-52] Mohamed Nour El-Din.csv";

    [TrainOut] = LEASTSQUARES_nClass_Train(filename, '');
    DetectIn.('TrainOut') = TrainOut;

    filename = "/home/rho/Documents/GP/bAnalyzer/master/Data/Detection/oldData/[D][2014-03-01 16-48-36] Mohamed Nour El-Din.csv";
    
    [Data, HDR] = getRawData(filename);
    fs=HDR.SampleRate;
    printMatrix = [];
    accuracy = 0;
    HDR.TRIG = HDR.TRIG+1 ; %%why +1 ?? 
	length(HDR.TRIG)    
    for k =1:length(HDR.TRIG)
            Dstart = HDR.TRIG(k);
            Dend =  HDR.TRIG(k)+fs*4-1;
            DetectIn.('TrialData') =  Data(Dstart : Dend ,:)' ;
            
            [DetectOut Debug] = LEASTSQUARES_nClass_Detect(DetectIn,'');
            
            output=getClassNumber(HDR, DetectOut);
            
			disp(['It should be     ' num2str(HDR.Classlabel(k))  '     and it is     '  num2str(output)])
           
  	        if(output == HDR.Classlabel(k))
                accuracy=accuracy+1;
            end
    end

    accuracy = accuracy/(length(HDR.TRIG));
    printMatrix = [printMatrix accuracy];
    disp(['acurracy of detection = ' num2str(printMatrix*100) '%']);

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
