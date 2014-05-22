function NavStep = Right_Vs_Left_Frequency_Range(DataOut,TrialNumber = 1,ChannelName = "FC6")
    
    ChannelNumber = getChannelNumber(DataOut.HDR, ChannelName);
    numElements = size(DataOut.Freq_mu_Sorted_AfterTrigger)(2);
    
    Mu_Min = DataOut.Mu_Min;
    Mu_Max = DataOut.Mu_Max;
    Be_Min = DataOut.Beta_Min;
    Be_Max = DataOut.Beta_Max;
    
    HDR = DataOut.HDR;
    fs=HDR.SampleRate;
    f=linspace(-fs/2,fs/2,numElements);
    range_mu = (f>(Mu_Min-1) & f<(Mu_Max+1));
    range_be = (f>(Be_Min-1) & f<(Be_Max+1));

    
    figure(1);
    subplot(2,2,1);
    %plot(range,[Freq_mu_Sorted(ChannelNumber, range, TrialNumber); Freq_mu_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber+1)]);
    plot(f(range_mu),[DataOut.Freq_mu_Sorted(ChannelNumber, range_mu, TrialNumber); DataOut.Freq_mu_Sorted(ChannelNumber, range_mu, TrialNumber+1)]);
    legend(["Mu of " ChannelName " Right (FreqDomain)"], ["Mu of " ChannelName " Left (FreqDomain)"]);
    
    subplot(2,2,3);
    plot(f(range_mu),DataOut.Freq_mu_Sorted(ChannelNumber, range_mu, TrialNumber) - DataOut.Freq_mu_Sorted(ChannelNumber, range_mu, TrialNumber+1));
    legend(["Diff. of Mu Right - Left" ChannelName " (FreqDomain)"]);
    
    subplot(2,2,2);
    plot(f(range_be),[DataOut.Freq_be_Sorted(ChannelNumber, range_be, TrialNumber); DataOut.Freq_be_Sorted(ChannelNumber, range_be, TrialNumber+1)]);
    legend(["Beta of " ChannelName " Right (FreqDomain)"], ["Beta of " ChannelName " Left (FreqDomain)"]);
    
    subplot(2,2,4);
    plot(f(range_be),DataOut.Freq_be_Sorted(ChannelNumber, range_be, TrialNumber) - DataOut.Freq_be_Sorted(ChannelNumber, range_be, TrialNumber+1));
    legend(["Diff. of Beta Right - Left " ChannelName " (FreqDomain)"]);
    
    NavStep = 2;
end