function trialsData = getTrialsData(directory, startTime=0, endTime=4, type = '1')
    % use size(trialsData)(1) to get channel number     ie: 14  channels
    % use size(trialsData)(2) to get samples/trial      ie: 512 samples
    % use size(trialsData)(3) to get the trials number  ie: 100 trials
    % type = 0 -> old files
    % type = 1 -> new files

    startTime = int32(startTime);
    endTime = int32(endTime);

    [Data, HDR] = getRawData(directory);
    
    HDR.TRIG = HDR.TRIG+1;
    fs          = HDR.SampleRate;
    TrialNum    = length(HDR.TRIG);
    ChannelsNo  = size(Data)(2);
    samplesNo   = (int32(endTime) - int32(startTime)) * fs;
    
    trialsData = zeros(ChannelsNo, samplesNo, TrialNum);
    
    for k =1:length(HDR.TRIG)

        Dstart  = HDR.TRIG(k) + startTime*fs;
        Dend    = HDR.TRIG(k) + endTime*fs-1;

        if(Dend > length(Data))
             lastTrial = Data(Dstart:end,:)';
             trialsData(:,1:size(lastTrial)(2),k) = lastTrial ;
        else
            trialsData(:,:,k)   = Data(Dstart:Dend,:)';
           
        end
    end
   
end