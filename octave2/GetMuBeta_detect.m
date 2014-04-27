 function [mu,Beta] = GetMuBeta_detect(data)

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
        fs = 128;
	nChannels = size(data)(1);
	mu   = zeros(1,nChannels);
	Beta = zeros(1,nChannels);
	[Am Bm] = butter(5,[10/(fs/2) 12/(fs/2)] ,'pass');
	[Ab Bb] = butter(5,[16/(fs/2) 24/(fs/2)] ,'pass');

	for f = 1:nChannels
		Data      =  data(f,:);
		Data_mu   =  filter(Am,Bm,Data);
		Data_be   =  filter(Ab,Bb,Data);
		mu(1,f)   =  mean(abs(fft(Data_mu)/length(Data_mu) )) ;
		Beta(1,f) =  mean(abs(fft(Data_be)/length(Data_be) )) ; %eshm3na el mean leh mesh el RMS mathlan ?! 
	end
end
