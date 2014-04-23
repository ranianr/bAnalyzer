 function [mu,Beta] = GetMuBeta(start, endD, data,HDR)
	
	fs=HDR.SampleRate;

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
				Data      =  [ temp(HDR.TRIG(k)+(start)*250 : end) ] ;
				Data_mu   =  filter(Am,Bm,Data);
				Data_be   =  filter(Ab,Bb,Data);
				mu(k,f)   =  mean(abs(fft(Data_mu)/length(Data_mu) )) ;
				Beta(k,f) =  mean(abs(fft(Data_be)/length(Data_be) )) ;%eshm3na el mean leh mesh el RMS mathlan ?! 		
			else
				Data      =  [ temp(HDR.TRIG(k)+(start)*fs : HDR.TRIG(k)+fs*(endD)-1) ] ;
				Data_mu   =  filter(Am,Bm,Data);
				Data_be   =  filter(Ab,Bb,Data);
				mu(k,f)   =  mean(abs(fft(Data_mu)/length(Data_mu) )) ;
				Beta(k,f) =  mean(abs(fft(Data_be)/length(Data_be) )) ;%eshm3na el mean leh mesh el RMS mathlan ?! 
			end
		end
	end
end
