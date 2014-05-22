function DataOut = test1( FilePath = "/home/rho/Documents/GP/[2014-03-23] Braingizer/Data/TrainingData/Session_2014_04_17_82423/[T][2014-04-17 23-06-15] Ahmed Hemaly.csv",
                                    ChannelName = "FC6",
                                    Mu_Min = 9,     %10
                                    Mu_Max = 11,    %12
                                    Beta_Min = 15,  %16
                                    Beta_Max = 17)  %24
    
    addpath("/home/medo/Work/GP/[2014-03-23] Braingizer/Detector/Classifiers/RawDataFunctions");
    
    [data, HDR] = getRawData(FilePath);
    
    fs=HDR.SampleRate; %sample/sec commented because getrawdata don't return it, as it's known for emotive headset and is 128 sample/sec

    nChannels = size(data);
    DataLength= nChannels(1);
    nChannels = nChannels(2);

    length_of_time=3*fs;
    Freq_mu         = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_be         = zeros(nChannels,length_of_time,length(HDR.TRIG));    
    Freq_mu_Sorted  = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_be_Sorted  = zeros(nChannels,length_of_time,length(HDR.TRIG));
    
    Freq_mu_BeforeTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_be_BeforeTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_mu_Sorted_BeforeTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_be_Sorted_BeforeTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    
    Time_mu         = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_be         = zeros(nChannels,length_of_time,length(HDR.TRIG));    
    Time_mu_Sorted  = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_be_Sorted  = zeros(nChannels,length_of_time,length(HDR.TRIG));
    
    Time_mu_BeforeTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_be_BeforeTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_mu_Sorted_BeforeTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_be_Sorted_BeforeTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    
    %Beta = zeros(length(HDR.TRIG),nChannels);
    
    [Am Bm] = butter(5,[Mu_Min/(fs/2) Mu_Max/(fs/2)] ,'pass');
    [Ab Bb] = butter(5,[Beta_Min/(fs/2) Beta_Max/(fs/2)] ,'pass');

    for f = 1:nChannels
            temp = data(:,f)';
            for k =1:length(HDR.TRIG)
                Data            =  [ temp(HDR.TRIG(k)+1*fs : HDR.TRIG(k)+fs*4-1) ] ;
                Freq_mu(f,:,k)  =  fftshift(real(fft(filter(Am,Bm,Data))));
                Freq_be(f,:,k)  =  fftshift(real(fft(filter(Ab,Bb,Data))));
                Time_mu(f,:,k)  =  filter(Am,Bm,Data);
                Time_be(f,:,k)  =  filter(Ab,Bb,Data);
                
                Data_BeforeTrigger              =  [ temp(HDR.TRIG(k)-3*fs : HDR.TRIG(k)+fs*0-1) ] ;
                Freq_mu_BeforeTrigger(f,:,k)    =  fftshift(real(fft(filter(Am,Bm,Data_BeforeTrigger))));
                Freq_be_BeforeTrigger(f,:,k)    =  fftshift(real(fft(filter(Ab,Bb,Data_BeforeTrigger))));
                Time_mu_BeforeTrigger(f,:,k)    =  filter(Am,Bm,Data_BeforeTrigger);
                Time_be_BeforeTrigger(f,:,k)    =  filter(Ab,Bb,Data_BeforeTrigger);
            end
    end
    
    R = getClassNumber(HDR,'RIGHT');
    L = getClassNumber(HDR,'LEFT');
    
    Freq_mu_Sorted(:,:,1:2:end) = Freq_mu(:,:,HDR.Classlabel==R);
    Freq_mu_Sorted(:,:,2:2:end) = Freq_mu(:,:,HDR.Classlabel==L);
    Freq_be_Sorted(:,:,1:2:end) = Freq_be(:,:,HDR.Classlabel==R);
    Freq_be_Sorted(:,:,2:2:end) = Freq_be(:,:,HDR.Classlabel==L);
    
    Freq_mu_Sorted_BeforeTrigger(:,:,1:2:end) = Freq_mu_BeforeTrigger(:,:,HDR.Classlabel==R);
    Freq_mu_Sorted_BeforeTrigger(:,:,2:2:end) = Freq_mu_BeforeTrigger(:,:,HDR.Classlabel==L);
    Freq_be_Sorted_BeforeTrigger(:,:,1:2:end) = Freq_be_BeforeTrigger(:,:,HDR.Classlabel==R);
    Freq_be_Sorted_BeforeTrigger(:,:,2:2:end) = Freq_be_BeforeTrigger(:,:,HDR.Classlabel==L);
    
    Time_mu_Sorted(:,:,1:2:end) = Time_mu(:,:,HDR.Classlabel==R);
    Time_mu_Sorted(:,:,2:2:end) = Time_mu(:,:,HDR.Classlabel==L);
    Time_be_Sorted(:,:,1:2:end) = Time_be(:,:,HDR.Classlabel==R);
    Time_be_Sorted(:,:,2:2:end) = Time_be(:,:,HDR.Classlabel==L);
    
    Time_mu_Sorted_BeforeTrigger(:,:,1:2:end) = Time_mu_BeforeTrigger(:,:,HDR.Classlabel==R);
    Time_mu_Sorted_BeforeTrigger(:,:,2:2:end) = Time_mu_BeforeTrigger(:,:,HDR.Classlabel==L);
    Time_be_Sorted_BeforeTrigger(:,:,1:2:end) = Time_be_BeforeTrigger(:,:,HDR.Classlabel==R);
    Time_be_Sorted_BeforeTrigger(:,:,2:2:end) = Time_be_BeforeTrigger(:,:,HDR.Classlabel==L);
    
    % Out for python
    DataOut.Freq_mu_Sorted = Freq_mu_Sorted;
    DataOut.Freq_be_Sorted = Freq_be_Sorted;
    DataOut.Freq_mu_Sorted_BeforeTrigger = Freq_mu_Sorted_BeforeTrigger;
    DataOut.Freq_be_Sorted_BeforeTrigger = Freq_be_Sorted_BeforeTrigger;
    DataOut.Time_mu_Sorted = Time_mu_Sorted;
    DataOut.Time_be_Sorted = Time_be_Sorted;
    DataOut.Time_mu_Sorted_BeforeTrigger = Time_mu_Sorted_BeforeTrigger;
    DataOut.Time_be_Sorted_BeforeTrigger = Time_be_Sorted_BeforeTrigger;
    
    TrialNumber = 1;
    range = 1:(length_of_time);
    
    ChannelNumber = getChannelNumber(HDR, ChannelName);
    
    while(1)
        figure(1);
        subplot(2,2,1);
        %plot(range,[Freq_mu_Sorted(ChannelNumber, range, TrialNumber); Freq_mu_Sorted(ChannelNumber, range, TrialNumber+1)]);
        plot(range,[Freq_mu_Sorted(ChannelNumber, range, TrialNumber); Freq_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)]);
        legend(["Mu of " ChannelName " After Trigger (FreqDomain)"], ["Mu of " ChannelName " Before Trigger (FreqDomain)"]);
        
        subplot(2,2,3);
        plot(Freq_mu_Sorted(ChannelNumber, range, TrialNumber) - Freq_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber));
        legend(["Diff. of Mu " ChannelName " (FreqDomain)"]);
        
        subplot(2,2,2);
        plot(range,[Freq_be_Sorted(ChannelNumber, range, TrialNumber); Freq_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)]);
        legend(["Beta of " ChannelName " After Trigger (FreqDomain)"], ["Beta of " ChannelName " Before Trigger (FreqDomain)"]);
        
        subplot(2,2,4);
        plot(Freq_be_Sorted(ChannelNumber, range, TrialNumber) - Freq_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber));
        legend(["Diff. of Beta " ChannelName " (FreqDomain)"]);
        
        TrialNumber = TrialNumber + 1;
        
        figure(2);
        subplot(2,2,1);
        %plot(range,[Time_mu_Sorted(ChannelNumber, range, TrialNumber); Time_mu_Sorted(ChannelNumber, range, TrialNumber+1)]);
        plot(range,[Time_mu_Sorted(ChannelNumber, range, TrialNumber); Time_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)]);
        legend(["Mu of " ChannelName " After Trigger (TimeDomain)"], ["Mu of " ChannelName " Before Trigger (TimeDomain)"]);
        
        subplot(2,2,3);
        plot(Time_mu_Sorted(ChannelNumber, range, TrialNumber) - Time_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber));
        legend(["Diff. of Mu " ChannelName " (TimeDomain)"]);
        
        subplot(2,2,2);
        plot(range,[Time_be_Sorted(ChannelNumber, range, TrialNumber); Time_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)]);
        legend(["Beta of " ChannelName " After Trigger (TimeDomain)"], ["Beta of " ChannelName " Before Trigger (TimeDomain)"]);
        
        subplot(2,2,4);
        plot(Time_be_Sorted(ChannelNumber, range, TrialNumber) - Time_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber));
        legend(["Diff. of Beta " ChannelName " (TimeDomain)"]);
        
        TrialNumber = TrialNumber + 1;
        pause();
    end
end
