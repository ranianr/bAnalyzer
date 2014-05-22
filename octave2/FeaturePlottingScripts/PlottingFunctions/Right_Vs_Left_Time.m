function NavStep = Right_Vs_Left_Time(DataOut,TrialNumber = 1,ChannelName = "FC6")
    
    ChannelNumber = getChannelNumber(DataOut.HDR, ChannelName);
    range = 1:size(DataOut.Time_mu_Sorted)(2);

     
    figure(1);
    subplot(2,2,1);
    %plot(range,[Time_mu_Sorted(ChannelNumber, range, TrialNumber); Time_mu_Sorted(ChannelNumber, range, TrialNumber+1)]);
    plot(range,[DataOut.Time_mu_Sorted(ChannelNumber, range, TrialNumber); DataOut.Time_mu_Sorted(ChannelNumber, range, TrialNumber+1)]);
    legend(["Mu of " ChannelName " Right (TimeDomain)"], ["Mu of " ChannelName " Left (TimeDomain)"]);
    
    subplot(2,2,3);
    plot(DataOut.Time_mu_Sorted(ChannelNumber, range, TrialNumber) - DataOut.Time_mu_Sorted(ChannelNumber, range, TrialNumber+1));
    legend(["Diff. of Mu Right - Left " ChannelName " (TimeDomain)"]);
    
    subplot(2,2,2);
    plot(range,[DataOut.Time_be_Sorted(ChannelNumber, range, TrialNumber); DataOut.Time_be_Sorted(ChannelNumber, range, TrialNumber+1)]);
    legend(["Beta of " ChannelName " Right (TimeDomain)"], ["Beta of " ChannelName " Left (TimeDomain)"]);
    
    subplot(2,2,4);
    plot(DataOut.Time_be_Sorted(ChannelNumber, range, TrialNumber) -DataOut. Time_be_Sorted(ChannelNumber, range, TrialNumber+1));
    legend(["Diff. of Beta Right - Left " ChannelName " (TimeDomain)"]);
    
    NavStep = 2;
end