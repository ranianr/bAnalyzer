function accuracy = fisherTest(data, t, w, Wo)
X1 = data(find(t == 1),:);
X2 = data(find(t == -1),:);
y1 = 0;
y2 = 0;
	y1 = w'*X1';
	y2 = w'*X2';
y1 += Wo;
y2 += Wo;
y = [y1 , y2];
y(y>0) = 1;
y(y<0) = -1;
difference= y  -  t;
difference(difference~= 0) =1;
accuracy = (1 - mean(difference))*100;

end
