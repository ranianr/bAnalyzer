function NavStep = Before_Vs_After_Time(DataOut,TrialNumber = 1,ChannelName = "FC6")
    
    ChannelNumber = getChannelNumber(DataOut.HDR, ChannelName);
    range = 1:size(DataOut.Time_mu_Sorted_AfterTrigger)(2);

     
    figure(1);
    subplot(2,2,1);
    %plot(range,[Time_mu_Sorted(ChannelNumber, range, TrialNumber); Time_mu_Sorted(ChannelNumber, range, TrialNumber+1)]);
    plot(range,[DataOut.Time_mu_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber); DataOut.Time_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)]);
    legend(["Mu of " ChannelName " After Trigger (TimeDomain)"], ["Mu of " ChannelName " Before Trigger (TimeDomain)"]);
    
    subplot(2,2,3);
    plot(DataOut.Time_mu_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber) - DataOut.Time_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber));
    legend(["Diff. of Mu " ChannelName " (TimeDomain)"]);
    
    subplot(2,2,2);
    plot(range,[DataOut.Time_be_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber); DataOut.Time_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)]);
    legend(["Beta of " ChannelName " After Trigger (TimeDomain)"], ["Beta of " ChannelName " Before Trigger (TimeDomain)"]);
    
    subplot(2,2,4);
    plot(DataOut.Time_be_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber) -DataOut. Time_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber));
    legend(["Diff. of Beta " ChannelName " (TimeDomain)"]);
    
    NavStep = 1;
end