 function [mu,Beta] = GetMuBeta(data,HDR)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{

Input :
%%%%%%%%
directory         : string containg the gdf file path
Channel_selection : A string specify what channels to take, have three 
                    possible casses 
channels_no       : vector of integer numbers 

all possible casses
--------------------
1 - Channel_selection = "Group" this will allow you to choose any group
                         of channels 
    channels_no = [ 22 3 4 6 60] "any group of numbers in range"

2 - Channel_selection = "Range" this will allow you to choose a range 
                         of channels 
    channels_no = [ 3 5] "only two numbers : [start, END]

3 - Channel_selection = "noone" or just any 4 letters this will refer
                        that you need just all channels 
    channels_no = XXXXX : don't care, but define it to avoid errors

=======================================================================
Output :
%%%%%%%%
HDR        : The header structure of the gdf file 
mu         : The mu values from 4 sec to 7sec after the trigger (columns=nChannels)
Beta       : The Beta values from 4 sec to 7sec after the trigger (columns=nChannels)  
nChannels  : The number of channels you choosed in data matrix (columns)
DataLength : The length of the data in the data matrix (Rows)
data       : Just the raw data from the gdf file

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	
	fs=HDR.SampleRate; %sample/sec commented because getrawdata don't return it, as it's known for emotive headset and is 128 sample/sec

	nChannels = size(data);
	DataLength= nChannels(1);
	nChannels = nChannels(2);


	mu   = zeros(length(HDR.TRIG),nChannels);
	Beta = zeros(length(HDR.TRIG),nChannels);

	[Am Bm] = butter(5,[10/(fs/2) 12/(fs/2)] ,'pass');
	[Ab Bb] = butter(5,[16/(fs/2) 24/(fs/2)] ,'pass');

	for f = 1:nChannels
		temp = data(:,f);
		for k =1:length(HDR.TRIG)
			if(k==length(HDR.TRIG))
				Data      =  [ temp(HDR.TRIG(k)+0*250 : end) ] ;
				Data_mu   =  filter(Am,Bm,Data);
				Data_be   =  filter(Ab,Bb,Data);
				mu(k,f)   =  mean(abs(fft(Data_mu)/length(Data_mu) )) ;
				Beta(k,f) =  mean(abs(fft(Data_be)/length(Data_be) )) ;%eshm3na el mean leh mesh el RMS mathlan ?! 		
			else
				Data      =  [ temp(HDR.TRIG(k)+0*fs : HDR.TRIG(k)+fs*4-1) ] ;
				Data_mu   =  filter(Am,Bm,Data);
				Data_be   =  filter(Ab,Bb,Data);
				mu(k,f)   =  mean(abs(fft(Data_mu)/length(Data_mu) )) ;
				Beta(k,f) =  mean(abs(fft(Data_be)/length(Data_be) )) ;%eshm3na el mean leh mesh el RMS mathlan ?! 
			end
		end
	end
end
