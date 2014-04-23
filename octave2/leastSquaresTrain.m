function [w, t, x] = leastsquaresTrain(C1, C2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Input :
%%%%%%%%
mu   : The mu values from 4 sec to 7sec after the trigger (columns=nChannels)
Beta : The Beta values from 4 sec to 7sec after the trigger (columns=nChannels)  
t    : is a vector having same length of mu contining two values 
            only -1 -> class1 and 1 -> class2 
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t = [ones(1,size(C1)(1))  -1*ones(1,size(C2)(1))]';
    x = [[C1; C2], ones(length(t), 1)];
    w = inv(x'*x)*x'*t;
end
