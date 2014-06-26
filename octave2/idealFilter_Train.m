function [mu,Beta] = idealFilter_Train(data,HDR,startTime = 0,endTime = 4,operation = @mean,Mu_Min = 10,Mu_Max = 12,Beta_Min = 16,Beta_Max = 24)

    fs          = HDR.SampleRate;
    TrialNum    = length(HDR.TRIG);
    ChannelsNo  = size(data)(2);
    samplesNo   = (endTime - startTime)*fs;
    mu = zeros(TrialNum,ChannelsNo);
    Beta = zeros(TrialNum,ChannelsNo);
    
    freq = linspace(0,fs,fs*(endTime - startTime));
    
    for k =1:length(HDR.TRIG)
        Dstart  = HDR.TRIG(k) + startTime*fs;
        Dend    = HDR.TRIG(k) + endTime*fs-1;
        
        
        
		if(Dend > length(data))
			tempData = data(Dstart:length(data),:)';
		else
			tempData = data(Dstart:Dend,:)';
		endif 
                [mu(k,:) ,Beta(k,:)] = idealFilter(tempData,operation,fs,Mu_Min,Mu_Max,Beta_Min,Beta_Max);
        
        end
end
