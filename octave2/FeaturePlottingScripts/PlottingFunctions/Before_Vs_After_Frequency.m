function NavStep = Before_Vs_After_Frequency(DataOut,TrialNumber = 1,ChannelName = "FC6")
    
    ChannelNumber = getChannelNumber(DataOut.HDR, ChannelName);
    range = 1:size(DataOut.Freq_mu_Sorted_AfterTrigger)(2);

    
    figure(1);
    subplot(2,2,1);
    %plot(range,[Freq_mu_Sorted(ChannelNumber, range, TrialNumber); Freq_mu_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber+1)]);
    plot(range,[DataOut.Freq_mu_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber); DataOut.Freq_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)]);
    legend(["Mu of " ChannelName " After Trigger (FreqDomain)"], ["Mu of " ChannelName " Before Trigger (FreqDomain)"]);
    
    subplot(2,2,3);
    plot(DataOut.Freq_mu_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber) - DataOut.Freq_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber));
    legend(["Diff. of Mu " ChannelName " (FreqDomain)"]);
    
    subplot(2,2,2);
    plot(range,[DataOut.Freq_be_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber); DataOut.Freq_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)]);
    legend(["Beta of " ChannelName " After Trigger (FreqDomain)"], ["Beta of " ChannelName " Before Trigger (FreqDomain)"]);
    
    subplot(2,2,4);
    plot(DataOut.Freq_be_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber) - DataOut.Freq_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber));
    legend(["Diff. of Beta " ChannelName " (FreqDomain)"]);
    
    NavStep = 1;
end