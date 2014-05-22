function NavStep = Right_Vs_Left_Frequency(DataOut,TrialNumber = 1,ChannelName = "FC6")
    
    ChannelNumber = getChannelNumber(DataOut.HDR, ChannelName);
    range = 1:size(DataOut.Freq_mu_Sorted)(2);

    
    figure(1);
    subplot(2,2,1);
    %plot(range,[Freq_mu_Sorted(ChannelNumber, range, TrialNumber); Freq_mu_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber+1)]);
    plot(range,[DataOut.Freq_mu_Sorted(ChannelNumber, range, TrialNumber); DataOut.Freq_mu_Sorted(ChannelNumber, range, TrialNumber+1)]);
    legend(["Mu of " ChannelName " Right (FreqDomain)"], ["Mu of " ChannelName " Left (FreqDomain)"]);
    
    subplot(2,2,3);
    plot(DataOut.Freq_mu_Sorted(ChannelNumber, range, TrialNumber) - DataOut.Freq_mu_Sorted(ChannelNumber, range, TrialNumber+1));
    legend(["Diff. of Mu Right - Left" ChannelName " (FreqDomain)"]);
    
    subplot(2,2,2);
    plot(range,[DataOut.Freq_be_Sorted(ChannelNumber, range, TrialNumber); DataOut.Freq_be_Sorted(ChannelNumber, range, TrialNumber+1)]);
    legend(["Beta of " ChannelName " Right (FreqDomain)"], ["Beta of " ChannelName " Left (FreqDomain)"]);
    
    subplot(2,2,4);
    plot(DataOut.Freq_be_Sorted(ChannelNumber, range, TrialNumber) - DataOut.Freq_be_Sorted(ChannelNumber, range, TrialNumber+1));
    legend(["Diff. of Beta Right - Left " ChannelName " (FreqDomain)"]);
    
    NavStep = 2;
end