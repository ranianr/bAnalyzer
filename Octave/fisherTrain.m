function [w, Wo] = fisherTrain(data, t)

X1 = data(find(t == 1),:);
X2 = data(find(t == -1),:);

%Get mean
m1 = mean(X1)';
m2 = mean(X2)';

%Get Sw
Sw = zeros(size(X1)(2));
for k = 1:1:size(X1)(1)
	Xn = X1(k, :)';
	Sw = Sw + (Xn-m1)*(Xn-m1)';
end

for k = 1:1:size(X2)(1)
	Xn = X2(k, :)';
	Sw = Sw + (Xn-m2)*(Xn-m2)';
end
%Get W
w = inv(Sw)*(m2 - m1);

%Get Wo
Wo=-(w')*(m1+m2)/2; 

end
