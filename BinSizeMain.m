%%
clear

binsdata = dir('SecData/*data');
graphs = dir(['SecData/' binsdata(1).name '/*data']);
features = dir( [ 'SecData/' binsdata(1).name '/' graphs(1).name '/*data.txt'] );
numBins = numel(binsdata);
numGraphs = numel(graphs);
numFeatures = numel(features);
si = 0;

numOfPairs = 30;
knownGraphs = 1:numBins;
noGoodK = zeros(numel(knownGraphs),numOfPairs);
index = zeros(numel(knownGraphs),numOfPairs,2);
M = zeros(numel(knownGraphs),numFeatures,numFeatures);
for q = knownGraphs
    s = numFeatures;
%   figure(q)
    fprintf('q = %d\n', q)
    CV = zeros(numFeatures);
    for i = 1:numFeatures
        for j = 1:numFeatures
        %fprintf('i = %d, j = %d\n', i, j);
            si = 0;
            for n = 1:numGraphs
                checksize = textread( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/' features(1).name ], '%f' );
                si = si + floor(numel(checksize)/2);
            end
            dataJI = zeros(si,3);
            idx = zeros(si,1); %%%                   
            beta = zeros(2,1);
            beta2 = zeros(2,1);
            sumBeta = 0;
            pos = 1;
            for n = 1:numGraphs
                dataJ = textread( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/' features(j).name ], '%f' );
                dataJ = dataJ(2:2:numel(dataJ));
                dataI = textread( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/' features(i).name ], '%f' );
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
            M(q,i,j) = sumBeta / numGraphs; % beta(1);
            %fprintf('M(i,j) = %f\n', M(q,i,j));
            % cJI = zeros(max(size(dataIJ)),1);
            cJI = log10(dataJI(Good,1)) - log10(dataJI(Good,2)) * M(q,i,j);
            CV(i,j) = calculateCV(cJI, numGraphs, idx(Good)); %%%
            %fprintf('CV(i,j) = %f\n', CV(i,j));

%             subplot(s,s,(i-1)*s+j)
%             for tes = 1:numGraphs
%                 plot(cJI(find(idx(Good) == tes)), 0,'*');
%                 hold on
%             end
        end
    end
    index(q,:,:) =  chooseIndex(CV, numOfPairs);
end

sizeindex = size(index);
sindex = sizeindex(2);

%%
% find noGoodK
clearvars dataJI
xs = zeros(1, numel(binsdata));
ys = zeros(1, numel(binsdata));
ss = zeros(1, numel(binsdata));
as = zeros(1, numel(binsdata));
ks = zeros(1, numel(binsdata));
kks = zeros(1, numel(binsdata));

for q = knownGraphs % 1:numBins
    fprintf('q = %d\n', q)
    graphs = dir(['SecData/' binsdata(q).name '/*data']);
    snapsSize = zeros(1,numel(graphs));
    for n = 1:numel(graphs)
        b = dir( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/*data.txt'] );
        checksize = textread( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/' b(1).name ], '%f' );
        snapsSize(n) = numel(checksize);
    end
    maxSize = max(snapsSize);
    
    x = zeros(numel(graphs), numel(b), maxSize);

    for n = 1:numel(graphs)
        % b - the features data
        b = dir( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/*data.txt'] );
        for m = 1:numel(b)
           x(n,m,1:snapsSize(n)) = textread( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/' b(m).name ], '%f' );
        end
    end
    
    s = size(x);
    
    for n = 1:numel(graphs)
        y = reshape(x(n,:,1:snapsSize(n)), [s(2) snapsSize(n)]);

        % Good - index where log wouldn't be complex
        Good = ones(size(y(index(q,1,1),:)));
        for k = 1:numOfPairs
            i = index(q,k,1);
            j = index(q,k,2);
            if numel(find(Good & (y(i,:) > 0 & y(j,:) > 0))) < 5
                noGoodK(q,k) = 1;
            else
                Good = Good & (y(i,:) > 0 & y(j,:) > 0);
            end
        end
        Good = reshape(Good,[1 numel(Good)]);
    end
end

%%
% calculate precent of success
for q = knownGraphs % 1:numBins
    fprintf('q = %d\n', q)
    bin = binsdata(q);
    graphs = dir(['SecData/' binsdata(q).name '/*data']);
    snapsSize = zeros(1,numel(graphs));
    for n = 1:numel(graphs)
        b = dir( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/*data.txt'] );
        checksize = textread( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/' b(1).name ], '%f' );
        snapsSize(n) = numel(checksize);
    end
    maxSize = max(snapsSize);
    
    x = zeros(numel(graphs), numel(b), maxSize);

    for n = 1:numel(graphs)
        % b - the features data
        b = dir( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/*data.txt'] );
        for m = 1:numel(b)
           x(n,m,1:snapsSize(n)) = textread( [ 'SecData/' binsdata(q).name '/' graphs(n).name '/' b(m).name ], '%f' );
        end
    end
    
    a = zeros(numOfPairs-numel(find(noGoodK(q,:))),1); % place realloc
    s = size(x);
    beta = zeros(1,2);
    p = zeros(numOfPairs-numel(find(noGoodK(q,:))),1); % place realloc
    check = zeros(1);
    si = 0;
    flags = zeros(numel(graphs),2);
    sizes = zeros(numel(graphs),1);
    
    for n = 1:numel(graphs)
        y = reshape(x(n,:,1:snapsSize(n)), [s(2) snapsSize(n)]);
        Good = ones(size(y(index(q,1,1),:)));
        for k = 1:numOfPairs
            i = index(q,k,1);
            j = index(q,k,2);
            if noGoodK(q,k) ~= 1
                Good = Good & (y(i,:) > 0 & y(j,:) > 0);
            end
        end
        
        nn = 1;
        for k = 1:numOfPairs
            i = index(q,k,1);
            j = index(q,k,2);
            if noGoodK(q,k) ~= 1
                p(nn,(si+1):(si+max(size(find(Good))))) = (numOfPairs-k+1)*(numOfPairs-k+1) * (log10(y(j,find(Good))) - M(q,i,j) * log10(y(i,find(Good))));
                nn = nn + 1;
            end
        end
        
%         % pca on p
%         coeff = pca(p(1:sindex,(si+1):(si+max(size(find(Good)))))');
%         a((si+1):(si+max(size(find(Good)))),1:3) = p(1:sindex,(si+1):(si+max(size(find(Good)))))' * coeff(:,1:3);

%         figure(q)    
%         plot(a((si+1):(si+max(size(find(Good)))),2), a((si+1):(si+max(size(find(Good)))),3), '*')
%         hold on
    
        check((si+1):(si+max(size(find(Good)))),1) = n * ones(max(size(find(Good))), 1);
        flags(n,:) = [si+1, si+max(size(find(Good)))];
        sizes(n) = max(size(find(Good)));
        si = si + max(size(find(Good)));
    end
    coeff = pca(p');
    a = p' * coeff;
%     idx = cluster(gm, a);
%     idx = kmeans(p ,numel(graphs));
    
%     obj = fitgmdist(p',numGraphs);
%     idx = cluster(obj,p');

    Z = linkage(p','ward','euclidean','savememory','on');
    idx = cluster(Z,'maxclust',numGraphs);
    Z2 = linkage(a(:,1:3),'ward','euclidean','savememory','on');
    idx2 = cluster(Z2,'maxclust',numGraphs);
    idx3 = kmeans(p, numGraphs);
    idx4 = kmeans(a(:,1:3)', numGraphs);
%     for k = 1:max(size(a))
%         text(a(k,2),a(k,3),num2str(idx(k)));
%     end
    
    xs(q) = str2double(bin.name(11:(numel(bin.name)-5)))/1000;
    fprintf('xs (%d) = %d\n', q, xs(q))
    ys(q) = CalcPercent( idx, sizes, flags );
    fprintf('ys (%d) = %f\n', q, ys(q))
    as(q) = CalcPercent( idx2, sizes, flags );
    fprintf('as (%d) = %f\n', q, as(q))
    ks(q) = CalcPercent( idx3, sizes, flags );
    kks(q) = CalcPercent( idx4, sizes, flags );
    ss(q) = min(snapsSize);
    % clearvars id
    % clearvars -except xs ys ss binsdata q
end

%%
%  figure(1)
% plot(sort(xs), ys(sort(xs)))
figure('Name','cluster')
plot(xs,ys, '*')
xlabel('Bins Size');
ylabel('Success Percent');
ax = gca;
ax.YLim = [0 100];
figure('Name','cluster after pca')
plot(xs,as, '*')
xlabel('Bins Size');
ylabel('Success Percent');
ax = gca;
ax.YLim = [0 100];
figure('Name','kmeans')
plot(xs,ks, '*')
xlabel('Bins Size');
ylabel('Success Percent');
ax = gca;
ax.YLim = [0 100];
figure('Name','kmeans after pca')
plot(xs,kks, '*')
xlabel('Bins Size');
ylabel('Success Percent');
ax = gca;
ax.YLim = [0 100];
