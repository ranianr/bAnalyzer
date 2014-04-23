function accuracy = classifyGetAccuracy(t,w,x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Input :
%%%%%%%%
t    : is a vector having same length of mu contining two values 
       only -1 -> class1 and 1 -> class2 
w    : The mu values from 4 sec to 7sec after the trigger (columns=nChannels)
x    : Data which needs to be classified 

Output :
%%%%%%%%
accuracy : The percentage of right classifications   
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	y = w(1)*x(:,1);
	if(length(w)>1)
		for k=2:length(w)-1
			y = y + w(k)*x(:,k);
		end
	end
	y=y+w(end);
 	y(y>0) = 1;
 	y(y<0) = -1;
	%h=[y,t];
	diff= y  -  t;
	diff(diff ~= 0) =1;
	accuracy = (1 - mean(diff))*100;

end
