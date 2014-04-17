function data = remove_noise(Data)
	noise = mean(Data')';
	data =  Data - noise;
end
