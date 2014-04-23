function acc = KNNtest (k, trainPoint, htrain, point, testPointsTarget)


YpTotal = [];
if(size(point)(2) == 1)
	trainPoint = [trainPoint, trainPoint];
	point = [point, point];
end
pointDistance = distancePoints(point,trainPoint);
	for r=1:size(point)(1)
		distance = pointDistance(r,:)';
		[dist index1] = sort(distance);
		nearestK = dist(2:k+1);
		nearestPointsIndex = index1(2:k+1);
		Ktargets = htrain(nearestPointsIndex);
		vote = sum(Ktargets);
		Yp = 0;%add else error = error +1
		if(vote > 0)
			YpTotal = [YpTotal; 1];
		elseif(vote < 0)
			YpTotal = [YpTotal; -1];
		else 
			target = htrain( distance == min(distance(2:k+1)));
			YpTotal = [YpTotal; target];
		endif
	end
targetDiff = testPointsTarget - YpTotal;
targetRef = targetDiff(targetDiff == 0 ) ; 
acc = length(targetRef) / length(YpTotal);
end

