%train the model to get the value of K 
function k = KNNtrain(point, t)
if(size(point)(2) == 1)
	point = [point, point];
end
pointDistance = distancePoints(point,point);

	for k=1:(size(point)(1)-1)
	err(k)=0;

		for r=1:size(point)(1)

			distance = pointDistance(r,:)';
			%sort the array to find the nearest K points 
			[dist index] = sort(distance);
			nearestK = dist(2:k+1);

			nearestPointsIndex = index(2:k+1);
			length(nearestPointsIndex);
	
		%calc Yp
			targetslength = length(t);
			Ktargets = t(nearestPointsIndex);
			
			vote = sum(Ktargets);
			Yp = 0;%add else error = error +1
			if(vote > 0)
				Yp = 1;
			elseif(vote < 0)
				Yp = -1;
			endif
			%compare Yp with real Y to cal the error
			if(Yp != t(r))
				err(k) = err(k) +1	;	
			end
		end
	end
	[a b] = min(err);
	k=b;
end
