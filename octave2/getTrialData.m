function TrialData = getTrialData(Data, TRIG, TrigIndx,trigLength)
    trial_start = TRIG;
    if(TrigIndx == trigLength)
	TrialData = Data(TRIG : end,:)'; 
    else
	trial_end = TRIG + 4*128 -1;
	TrialData = Data(trial_start:trial_end,:)';
    end
end
