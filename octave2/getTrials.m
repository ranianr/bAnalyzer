function TrialMean = getTrials(Data, HDR, fs = 128)
    %Data Size
        nChannels   = size(Data);
        DataLength  = nChannels(1);
        nChannels   = nChannels(2);
    
    %Initializing
        TrialMean   = zeros(length(HDR.TRIG),nChannels);
    
    %Get the mean of each trial, in freq. domain
        for f = 1:nChannels
            Temp = Data(:,f);
            for k =1:length(HDR.TRIG)
                Trial_Start = HDR.TRIG(k) - 0*fs;
                Trial_End   = HDR.TRIG(k) + 4*fs;
                if Trial_End > DataLength
                    Trial_End = DataLength;
                end
                
                Trial_Data      = [Temp(Trial_Start:Trial_End)];
                TrialMean(k,f)  =  mean(abs( fft(Trial_Data)/length(Trial_Data) )) ;
            end
        end
end
