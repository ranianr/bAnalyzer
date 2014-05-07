function TrialData = getTrialData(Data, TRIG, TrigIndx,trigLength, timeMin, timeMax, SampleRate)
    trial_start = TRIG + timeMin*SampleRate;
    if(TrigIndx == trigLength)
	TrialData = Data(TRIG : end,:)'; 
    else
	trial_end = TRIG + timeMax*SampleRate-1;
	TrialData = Data(trial_start:trial_end,:)';
    end
    trial_start
    trial_end
end
