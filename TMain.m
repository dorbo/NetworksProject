% Main
%%
clear

graphs = dir('TData/*data');
features = dir( [ 'TData/' graphs(1).name '/*data.txt'] );

numGraphs = numel(graphs);
numFeatures = numel(features);
snapsSize = zeros(1,numel(graphs));

si = 0;
for n = 1:numGraphs
    checkSize = textread( [ 'TData/' graphs(n).name '/' features(1).name ], '%f' );
    snapsSize(n) = numel(checkSize);
    si = si + floor(numel(checkSize)/2);
end

numOfPairs = 30;
CV = zeros(numFeatures);
for i = 1:numFeatures
    for j = 1:numFeatures
        dataJI = zeros(si,3);
        idx = zeros(si,1); %%%                   
        beta = zeros(2,1);
        beta2 = zeros(2,1);
        sumBeta = 0;
        pos = 1;
        for n = 1:numGraphs
            dataJ = textread( [ 'TData/' graphs(n).name '/' features(j).name ], '%f' );
            dataJ = dataJ(2:2:numel(dataJ));
            dataI = textread( [ 'TData/' graphs(n).name '/' features(i).name ], '%f' );
            dataI = dataI(2:2:numel(dataI));
            dataJI(pos:(pos + numel(dataJ) - 1),1) = dataJ;
            dataJI(pos:(pos + numel(dataI) - 1),2) = dataI;
            dataJI(pos:(pos + numel(dataI) - 1),3) = ones(numel(dataI),1);
            idx(pos:(pos + numel(dataI) - 1),1) = n * ones(numel(dataI),1); %%%
            Good2 = find(dataJ > 0 & dataI > 0);
            beta2 = regress(log10(dataJ(Good2)), [log10(dataI(Good2)) ones(numel(Good2),1)]);
            sumBeta = sumBeta + beta2(1); 
            pos = pos + numel(dataI);
        end
        Good = find(dataJI(:,1) > 0 & dataJI(:,2) >0);
        beta = regress(log10(dataJI(Good,1)), [log10(dataJI(Good,2)) dataJI(Good,3)]);
        M(i,j) = sumBeta / numGraphs; % beta(1);

        % cJI = zeros(max(size(dataIJ)),1);
        cJI = log10(dataJI(Good,1)) - log10(dataJI(Good,2)) * M(i,j);
        CV(i,j) = calculateCV(cJI, numGraphs, idx(Good)); %%%
    end
end
HeatMap(M)
HeatMap(CV)
index =  chooseIndex(CV, numOfPairs);
%%
% find noGoodK
clearvars dataJI

noGoodK = zeros(1, numOfPairs);

maxSize = max(snapsSize);

x = zeros(numel(graphs), numel(features), maxSize);

for n = 1:numGraphs
    for m = 1:numFeatures
       x(n,m,1:snapsSize(n)) = textread( [ 'TData/' graphs(n).name '/' features(m).name ], '%f' );
    end
end

s = size(x);
% Good - index where log wouldn't be complex
Good = ones(1,numel(x(n,index(1,1),:)));
    
for n = 1:numel(graphs)
    y = reshape(x(n,:,1:snapsSize(n)), [s(2) snapsSize(n)]);
    for k = 1:numOfPairs
        i = index(k,1);
        j = index(k,2);
        if numel(find(Good & (y(i,:) > 0 & y(j,:) > 0))) < 5
            noGoodK(k) = 1;
        else
            Good = Good & (y(i,:) > 0 & y(j,:) > 0);
        end
    end
end

Good = reshape(Good,[1 numel(Good)]);

%%
% calculate precent of success
    
a = zeros(numOfPairs - numel(find(noGoodK)),1);
s = size(x);
beta = zeros(1,2);
p = zeros(numOfPairs - numel(find(noGoodK)),1);
check = zeros(1);
si = 0;
flags = zeros(numel(graphs),2);
sizes = zeros(numel(graphs),1);

for n = 1:numel(graphs)
    y = reshape(x(n,:,1:snapsSize(n)), [s(2) snapsSize(n)]);
    
    for k = 1:numOfPairs
        i = index(k,1);
        j = index(k,2);
        if noGoodK(k) ~= 1
            p(k,(si+1):(si+max(size(find(Good))))) = (numOfPairs-k+1) * (log10(y(j,find(Good))) - M(i,j) * log10(y(i,find(Good))));          
        end
    end

%     % pca on p
%     coeff = pca(p(1:sindex,(si+1):(si+max(size(find(Good)))))');
%     a((si+1):(si+max(size(find(Good)))),1:3) = p(1:sindex,(si+1):(si+max(size(find(Good)))))' * coeff(:,1:3);

%         figure(1)    
%         plot(a((si+1):(si+max(size(find(Good)))),2), a((si+1):(si+max(size(find(Good)))),3), '*')
%         hold on

    check((si+1):(si+max(size(find(Good)))),1) = n * ones(max(size(find(Good))), 1);
    flags(n,:) = [si+1, si+max(size(find(Good)))];
    sizes(n) = max(size(find(Good)));
    si = si + max(size(find(Good)));    
end

% idx = cluster(gm, a);
coeff = pca(p');
a = p'*coeff;

%%
for n = 1:numel(graphs)
    plot(a(flags(n,1):flags(n,2),1),a(flags(n,1):flags(n,2),2),'*')
    hold on
end

% idx = kmeans(a(:,1:3)' ,numel(graphs));
% for k = 1:max(size(a))
%     text(a(k,1),a(k,2),num2str(idx(k)));
% end

%%
idx = kmeans(p,6); % a(:,1:3)' ,numel(graphs));
CalcPercent( idx, sizes, flags )

%%
Z = linkage(p','ward','euclidean','savememory','on');
idx = cluster(Z,'maxclust',numGraphs);
Z2 = linkage(a(:,1:3),'ward','euclidean','savememory','on');
idx2 = cluster(Z2,'maxclust',numGraphs);


CalcPercent( idx, sizes, flags )
CalcPercent( idx2, sizes, flags )

for k = 1:max(size(a))
    text(a(k,1),a(k,2),num2str(idx(k)));
end
%%
idx3 = kmeans(p, numGraphs);
idx4 = kmeans(a(:,1:3)', numGraphs);
CalcPercent( idx3, sizes, flags )
CalcPercent( idx4, sizes, flags )
