function NavStep = Nutral_Rejected_Right_Vs_Left_Time(DataOut,TrialNumber = 1,ChannelName = "FC6")
    
    ChannelNumber = getChannelNumber(DataOut.HDR, ChannelName);
    range = 1:size(DataOut.Time_mu_Sorted_AfterTrigger)(2);
    
    MuRight = DataOut.Time_mu_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber) - DataOut.Time_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)
    MuLeft  = DataOut.Time_mu_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber+1) - DataOut.Time_mu_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber+1)
    BetaRight   = DataOut.Time_be_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber) - DataOut.Time_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber)
    BetaLeft    = DataOut.Time_be_Sorted_AfterTrigger(ChannelNumber, range, TrialNumber+1) - DataOut.Time_be_Sorted_BeforeTrigger(ChannelNumber, range, TrialNumber+1)
    
    figure(1);
    subplot(2,2,1);
    plot(range,[MuRight; MuLeft]);
    legend(["Mu of " ChannelName " Right (Nutral Rejected) (TimeDomain)"], ["Mu of " ChannelName " Left (Nutral Rejected) (TimeDomain)"]);
    
    subplot(2,2,3);
    plot(MuRight - MuLeft);
    legend(["Diff. of Mu " ChannelName " (Right-Left) (Nutral Rejected) (TimeDomain)"]);
    
    subplot(2,2,2);
    plot(range,[BetaRight; BetaLeft]);
    legend(["Beta of " ChannelName " Right (Nutral Rejected) (TimeDomain)"], ["Beta of " ChannelName " Left (Nutral Rejected) (TimeDomain)"]);
    
    subplot(2,2,4);
    plot(BetaRight - BetaLeft);
    legend(["Diff. of Beta " ChannelName " (Right-Left) (Nutral Rejected) (TimeDomain)"]);
    
    NavStep = 2;
end