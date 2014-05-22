function [DataOut] = GetDataAnalysis( FilePath = "/media/ahmed/5CFEF97DFEF9502E/study/Graduation_Project/Octave/[2014-04-17] Hemaly's Data/[T][2014-04-17 23-06-15] Ahmed Hemaly.csv",
                                    %ChannelName = "FC6",
                                    Mu_Min = 9,     %10
                                    Mu_Max = 11,    %12
                                    Beta_Min = 15,  %16
                                    Beta_Max = 17,  %24
                                    Time_Min = 1,
                                    Time_Max = 4,
                                    RemoveNoise = false)
                                    %Time_Min_before = 3,
                                    %Time_Max_before = 0)
    
    %{
    FilePath    = Parameters.("FilePath");
    Mu_Min      = Parameters.("Mu_Min");
    Mu_Max      = Parameters.("Mu_Max");
    Beta_Min    = Parameters.("Beta_Min");
    Beta_Max    = Parameters.("Beta_Max");
    Time_Min    = Parameters.("Time_Min");
    Time_Max    = Parameters.("Time_Max");
    %}
    
    %{
    FilePath    = "/home/medo/Work/GP/[2014-03-23] Braingizer/Data/TrainingData/Session_2014_04_17_82423/[T][2014-04-17 23-06-15] Ahmed Hemaly.csv";
    Mu_Min      = 9;
    Mu_Max      = 11;
    Beta_Min    = 15;
    Beta_Max    = 17;
    Time_Min    = 0;
    Time_Max    = 4;
    %}
    
    addpath("/home/medo/Work/GP/[2014-03-23] Braingizer/Detector/Classifiers/RawDataFunctions");
    
    [data, HDR] = getRawData(FilePath);
    
    if RemoveNoise
        % Removing mean (All Channels)
        noise = mean(data')';
        data =  data - noise;
        
        %{
        % Removing mean (Channel by Channel)
        noise = mean(data);
        data =  data - noise;
        %}
    end
    

    
    fs=HDR.SampleRate; %sample/sec commented because getrawdata don't return it, as it's known for emotive headset and is 128 sample/sec

    nChannels = size(data);
    DataLength= nChannels(1);
    nChannels = nChannels(2);

    length_of_time=3*fs;
    length_of_time_norm = (Time_Max - Time_Min)*fs;
    Freq_mu         = zeros(nChannels,length_of_time_norm,length(HDR.TRIG));
    Freq_be         = zeros(nChannels,length_of_time_norm,length(HDR.TRIG));    
    Freq_mu_Sorted  = zeros(nChannels,length_of_time_norm,length(HDR.TRIG));
    Freq_be_Sorted  = zeros(nChannels,length_of_time_norm,length(HDR.TRIG));
    
    Freq_mu_BeforeTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_be_BeforeTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_mu_Sorted_BeforeTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_be_Sorted_BeforeTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    
    Freq_mu_AfterTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_be_AfterTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_mu_Sorted_AfterTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Freq_be_Sorted_AfterTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    
    Time_mu         = zeros(nChannels,length_of_time_norm,length(HDR.TRIG));
    Time_be         = zeros(nChannels,length_of_time_norm,length(HDR.TRIG));    
    Time_mu_Sorted  = zeros(nChannels,length_of_time_norm,length(HDR.TRIG));
    Time_be_Sorted  = zeros(nChannels,length_of_time_norm,length(HDR.TRIG));
    
    Time_mu_BeforeTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_be_BeforeTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_mu_Sorted_BeforeTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_be_Sorted_BeforeTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    
    Time_mu_AfterTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_be_AfterTrigger           = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_mu_Sorted_AfterTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    Time_be_Sorted_AfterTrigger    = zeros(nChannels,length_of_time,length(HDR.TRIG));
    
    %Beta = zeros(length(HDR.TRIG),nChannels);
    
    [Am Bm] = butter(5,[Mu_Min/(fs/2) Mu_Max/(fs/2)] ,'pass');
    [Ab Bb] = butter(5,[Beta_Min/(fs/2) Beta_Max/(fs/2)] ,'pass');

    for f = 1:nChannels
            temp = data(:,f)';
            for k =1:length(HDR.TRIG)
                Data      =  [ temp(HDR.TRIG(k)+Time_Min*fs : HDR.TRIG(k)+fs*Time_Max-1) ] ;
                Freq_mu(f,:,k)  =  fftshift(real(fft(filter(Am,Bm,Data))));
                Freq_be(f,:,k)  =  fftshift(real(fft(filter(Ab,Bb,Data))));
                Time_mu(f,:,k)  =  filter(Am,Bm,Data);
                Time_be(f,:,k)  =  filter(Ab,Bb,Data);
                
                %Data_AfterTrigger   =  [ temp(HDR.TRIG(k)+1*fs : HDR.TRIG(k)+fs*(Time_Min_before+1)-1) ] ;
                Data_AfterTrigger   =  [ temp(HDR.TRIG(k)+1*fs : HDR.TRIG(k)+fs*(4)-1) ] ;
                Freq_mu_AfterTrigger(f,:,k)    =  fftshift(real(fft(filter(Am,Bm,Data_AfterTrigger))));
                Freq_be_AfterTrigger(f,:,k)    =  fftshift(real(fft(filter(Ab,Bb,Data_AfterTrigger))));
                Time_mu_AfterTrigger(f,:,k)    =  filter(Am,Bm,Data_AfterTrigger);
                Time_be_AfterTrigger(f,:,k)    =  filter(Ab,Bb,Data_AfterTrigger);
                
                %Data_BeforeTrigger              =  [ temp(HDR.TRIG(k)-Time_min_before*fs : HDR.TRIG(k)+fs*Time_Max_before-1) ] ;
                Data_BeforeTrigger              =  [ temp(HDR.TRIG(k)-3*fs : HDR.TRIG(k)+fs*0 -1) ] ;
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
    
    Freq_mu_Sorted_AfterTrigger(:,:,1:2:end) = Freq_mu_AfterTrigger(:,:,HDR.Classlabel==R);
    Freq_mu_Sorted_AfterTrigger(:,:,2:2:end) = Freq_mu_AfterTrigger(:,:,HDR.Classlabel==L);
    Freq_be_Sorted_AfterTrigger(:,:,1:2:end) = Freq_be_AfterTrigger(:,:,HDR.Classlabel==R);
    Freq_be_Sorted_AfterTrigger(:,:,2:2:end) = Freq_be_AfterTrigger(:,:,HDR.Classlabel==L);
    
    Time_mu_Sorted(:,:,1:2:end) = Time_mu(:,:,HDR.Classlabel==R);
    Time_mu_Sorted(:,:,2:2:end) = Time_mu(:,:,HDR.Classlabel==L);
    Time_be_Sorted(:,:,1:2:end) = Time_be(:,:,HDR.Classlabel==R);
    Time_be_Sorted(:,:,2:2:end) = Time_be(:,:,HDR.Classlabel==L);
    
    Time_mu_Sorted_BeforeTrigger(:,:,1:2:end) = Time_mu_BeforeTrigger(:,:,HDR.Classlabel==R);
    Time_mu_Sorted_BeforeTrigger(:,:,2:2:end) = Time_mu_BeforeTrigger(:,:,HDR.Classlabel==L);
    Time_be_Sorted_BeforeTrigger(:,:,1:2:end) = Time_be_BeforeTrigger(:,:,HDR.Classlabel==R);
    Time_be_Sorted_BeforeTrigger(:,:,2:2:end) = Time_be_BeforeTrigger(:,:,HDR.Classlabel==L);
    
    Time_mu_Sorted_AfterTrigger(:,:,1:2:end) = Time_mu_AfterTrigger(:,:,HDR.Classlabel==R);
    Time_mu_Sorted_AfterTrigger(:,:,2:2:end) = Time_mu_AfterTrigger(:,:,HDR.Classlabel==L);
    Time_be_Sorted_AfterTrigger(:,:,1:2:end) = Time_be_AfterTrigger(:,:,HDR.Classlabel==R);
    Time_be_Sorted_AfterTrigger(:,:,2:2:end) = Time_be_AfterTrigger(:,:,HDR.Classlabel==L);
    
    % Out for python
    DataOut.HDR = HDR;
    
    DataOut.Freq_mu_Sorted = Freq_mu_Sorted;
    DataOut.Freq_be_Sorted = Freq_be_Sorted;
    DataOut.Time_mu_Sorted = Time_mu_Sorted;
    DataOut.Time_be_Sorted = Time_be_Sorted;
    
    DataOut.Freq_mu_Sorted_BeforeTrigger = Freq_mu_Sorted_BeforeTrigger;
    DataOut.Freq_be_Sorted_BeforeTrigger = Freq_be_Sorted_BeforeTrigger;
    DataOut.Time_mu_Sorted_BeforeTrigger = Time_mu_Sorted_BeforeTrigger;
    DataOut.Time_be_Sorted_BeforeTrigger = Time_be_Sorted_BeforeTrigger;
    
    DataOut.Freq_mu_Sorted_AfterTrigger = Freq_mu_Sorted_AfterTrigger;
    DataOut.Freq_be_Sorted_AfterTrigger = Freq_be_Sorted_AfterTrigger;
    DataOut.Time_mu_Sorted_AfterTrigger = Time_mu_Sorted_AfterTrigger;
    DataOut.Time_be_Sorted_AfterTrigger = Time_be_Sorted_AfterTrigger;
end
