function [eigVec, projected]=pcaProject(pureData)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
input : 
%%%%%%%
pureData : where the no. of channels is the no. of columns
           and the no. of raws is the no. of triggers where 
           in this raw you have the MU and Beta of each trigger 

output :
%%%%%%%%
eigVec : is a square matrix where the eigine vectors are the
         columns the last column they are in order such that
         the last one is for pinciple component 1 

projected : is a MXN matrix containing the output dimensions which
            is the projection of the data on the eigin vectors
            directions, the data is in the raws not columns
            (((ordered where the first PC is in raw 1))) 
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	nChannels = size(pureData)(2)
	x_Mean = mean(pureData);
	s_channel = zeros(nChannels);
	for n = 1: size(pureData)(2)
		k = (pureData(n,:) - x_Mean);
		s_channel = s_channel + (k * k') ;
	end

	[ eigVec Lamda] = eig(s_channel');

	%{
	for k = 1:length(eigVec)
		projected(k,:) = eigVec(:,end-k+1)'* pureData';
	end
        %}
	projected = eigVec'* pureData';
end
