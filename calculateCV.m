function [ cv ] = calculateCV(cJI, count, idxJI)
[sizex, ~]=size(cJI);
% idxJI=zeros(sizex, 1);
% idxJI=kmeans(cJI,count);

%regression on the feature i as a function of j and j as the function of i is equel
%therefor only half the matrix is required 

% for evey two features, data has in 1st column the mean and the 2nd the std 
data = zeros(count,2);
for n = 1:count
    data(n,1) = mean(cJI(find(idxJI == n)));
    data(n,2) = std(cJI(find(idxJI == n)));
end

cvPairs=zeros(count);
for i=1:count
    for j=1:count
        if i~=j
        cvPairs(i,j)=(abs(data(i,1)-data(j,1)))/(data(i,2)+data(j,2));
        else
        cvPairs(i,j)=inf;
        end
    end
end

cv=min(min(cvPairs));

%{
%coefficient of variation
distancesum = 0;
%max(size(data)) because data is 2*numofgraphs matrix
for k = 1:max(size(data))
    for l = 1:max(size(data))
        distancesum=distancesum+abs(data(l)-data(k));
    end
end

distmean = distancesum/max(size(data));
covmean = mean(data(:,2));
cv = vpa(distmean/covmean);

%}

end

