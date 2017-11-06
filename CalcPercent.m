function [ per ] = CalcPercent( idx, sizes, flags )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n = max(size((sizes)));
count = zeros(n);

for i = 1:n
    for j = 1:n
        count(i,j) = numel(find( idx(flags(i,1):flags(i,2)) == j)); % /sizes(i);
    end
end

maxcount = zeros(n,1);
total = 0;

for m = 1:n
    maxcount = max(max(count));
    [ii,jj] = find(count == maxcount);
    i = ii(1);
    j = jj(1);
    total = total + maxcount;
    count(i,:) = 0;
    count(:,j) = 0;
end

per = 100 * total / sum(sizes);

end

