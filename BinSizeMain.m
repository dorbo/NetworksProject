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

xs = zeros(1, numel(binsdata));
ys = zeros(1, numel(binsdata));
ss = zeros(1, numel(binsdata));
as = zeros(1, numel(binsdata));
ks = zeros(1, numel(binsdata));
kks = zeros(1, numel(binsdata));
o1s = zeros(1, numel(binsdata));
o2s = zeros(1, numel(binsdata));
di1_s = zeros(1, numel(binsdata));
di2_s = zeros(1, numel(binsdata));
si1_s = zeros(1, numel(binsdata));
si2_s = zeros(1, numel(binsdata));
dbi1_s = zeros(1, numel(binsdata));
dbi2_s = zeros(1, numel(binsdata));
avg1_s = zeros(1, numel(binsdata));
avg2_s = zeros(1, numel(binsdata));

for q =  1:numBins % [125, 254, 405]
    fprintf('q = %d\n', q)
    s = numFeatures;
    M = zeros(numFeatures);
    index = zeros(numOfPairs,2);
    noGoodK = zeros(numOfPairs,1);
    CV = zeros(numFeatures);
    
    for i = 1:numFeatures
        for j = 1:numFeatures
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
            M(i,j) = sumBeta / numGraphs; % beta(1);
            % cJI = zeros(max(size(dataIJ)),1);
            cJI = log10(dataJI(Good,1)) - log10(dataJI(Good,2)) * M(i,j);
            CV(i,j) = calculateCV(cJI, numGraphs, idx(Good)); %%%

%             subplot(s,s,(i-1)*s+j)
%             for tes = 1:numGraphs
%                 plot(cJI(find(idx(Good) == tes)), 0,'*');
%                 hold on
%             end
        end
    end
    index =  chooseIndex(CV, numOfPairs);
    sindex = numOfPairs;

    clearvars dataJI

    % find noGoodK
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
        Good = ones(size(y(index(1,1),:)));
        for k = 1:numOfPairs
            i = index(k,1);
            j = index(k,2);
            if numel(find(Good & (y(i,:) > 0 & y(j,:) > 0))) < 5
                noGoodK(k) = 1;
            else
                Good = Good & (y(i,:) > 0 & y(j,:) > 0);
            end
        end
        Good = reshape(Good,[1 numel(Good)]);
    end
    
    % calculate precent of success
    bin = binsdata(q);
    graphs = dir(['SecData/' binsdata(q).name '/*data']);
    
    a = zeros(numOfPairs-numel(find(noGoodK)),1); % place realloc
    s = size(x);
    beta = zeros(1,2);
    p = zeros(numOfPairs-numel(find(noGoodK)),1); % place realloc
    check = zeros(1);
    si = 0;
    flags = zeros(numel(graphs),2);
    sizes = zeros(numel(graphs),1);
    
    for n = 1:numel(graphs)
        y = reshape(x(n,:,1:snapsSize(n)), [s(2) snapsSize(n)]);
        Good = ones(size(y(index(1,1),:)));
        for k = 1:numOfPairs
            i = index(k,1);
            j = index(k,2);
            if noGoodK(k) ~= 1
                Good = Good & (y(i,:) > 0 & y(j,:) > 0);
            end
        end
        
        nn = 1;
        for k = 1:numOfPairs
            i = index(k,1);
            j = index(k,2);
            if noGoodK(k) ~= 1
                p(nn,(si+1):(si+max(size(find(Good))))) = (numOfPairs-k+1) * (log10(y(j,find(Good))) - M(i,j) * log10(y(i,find(Good))));
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

%     xs(q) = str2double(bin.name(11:(numel(bin.name)-5)))/1000;
%     % consts
%     for nn = 1:5
%     figure(nn)
%         for n = 1:numGraphs
%                 plot(p(nn,flags(n,1):flags(n,2)),zeros(1,flags(n,2)-flags(n,1)+1),'Marker','*','LineStyle','none') %,'Color',colors(n),;
%                 hold on
%         end
%     end

%     HMobject = HeatMap(M)    
%     addTitle(HMobject,'M')
%     plot(HMobject)
%     HMobject = HeatMap(CV)
%     addTitle(HMobject,'CV')
%     plot(HMobject)
    
    Z = linkage(p','ward','euclidean','savememory','on');
    idx1 = cluster(Z,'maxclust',numGraphs);
    Z2 = linkage(a(:,1:3),'ward','euclidean','savememory','on');
    idx2 = cluster(Z2,'maxclust',numGraphs);
    idx3 = kmeans(p, numGraphs);
    idx4 = kmeans(a(:,1:3)', numGraphs);
%     for k = 1:max(size(a))
%         text(a(k,2),a(k,3),num2str(idx(k)));
%     end

    % calculating criterions to check the quality of kmeans clusters
    % 1 - after pca (3 first dimentions)
    % 2 - before pca - all data
    distM1 = pdist(a(:,1:3));
    distM1 = squareform(distM1);
    distM2 = pdist(p');
    distM2 = squareform(distM2);
    last_avg1 = 0;
    last_si1 = 0;
    last_di1 = 0;
    last_dbi1 = inf;
    prev1 = 0;
    last_avg2 = 0;
    last_si2 = 0;
    last_di2 = 0;
    last_dbi2 = inf;
    prev2 = 0;
    for t = 1:10
        cur_idx1 = kmeans(a(:,1:3)', numGraphs);
        di1 = dunns(numGraphs, distM1, cur_idx1);
        eva = evalclusters(a(:,1:3), cur_idx1', 'DaviesBouldin');
        dbi1 = eva.CriterionValues;
        eva = evalclusters(a(:,1:3), cur_idx1', 'silhouette');
        si1 = eva.CriterionValues;
        avg1 = (si1+di1)/2;
        cur1 = CalcPercent( cur_idx1, sizes, flags );
        
        if avg1 > last_avg1
           avg1_idx = cur_idx1;
           last_avg1 = avg1;
        end

        if si1 > last_si1
           si1_idx = cur_idx1;
           last_si1 = si1;
        end

        if di1 > last_di1
           di1_idx = cur_idx1;
           last_di1 = di1;
        end

        if dbi1 < last_dbi1
           dbi1_idx = cur_idx1;
           last_dbi1 = dbi1;
        end

        if cur1 > prev1
            prev1 = cur1;
            opt1_idx = cur_idx1;
        end
        
        cur_idx2 = kmeans(p, numGraphs);
        di2 = dunns(numGraphs, distM2, cur_idx2);
        eva = evalclusters(p', cur_idx2', 'DaviesBouldin');
        dbi2 = eva.CriterionValues;
        eva = evalclusters(p', cur_idx2', 'silhouette');
        si2 = eva.CriterionValues;
        avg2 = (si2+di2)/2;
        cur2 = CalcPercent( cur_idx2, sizes, flags );
        
        if avg2 > last_avg2
           avg2_idx = cur_idx2;
           last_avg2 = avg2;
        end

        if si2 > last_si2
           si2_idx = cur_idx2;
           last_si2 = si2;
        end

        if di2 > last_di2
           di2_idx = cur_idx2;
           last_di2 = di2;
        end

        if dbi2 < last_dbi2
           dbi2_idx = cur_idx2;
           last_dbi2 = dbi2;
        end
        
        if cur2 > prev2
            prev2 = cur2;
            opt2_idx = cur_idx2;
        end
    end
    
%     % plot 2d pca
%     figure(40)
%     for n = 1:numel(graphs)
%         plot(a(flags(n,1):flags(n,2),1),a(flags(n,1):flags(n,2),2),'*')
%         hold on
%     end
%     
%     Z = linkage(p(1,:)','ward','euclidean','savememory','on');
%     idx = cluster(Z,'maxclust',numGraphs);
%     for k = 1:max(size(a))
%         text(a(k,1),a(k,2),num2str(idx(k)));
%     end
%     
    xs(q) = str2double(bin.name(11:(numel(bin.name)-5)))/1000;
    fprintf('xs (%d) = %d\n', q, xs(q))
    ys(q) = CalcPercent( idx1, sizes, flags ); % hirerchial clustering before pca
    fprintf('ys (%d) = %d\n', q, ys(q))
    as(q) = CalcPercent( idx2, sizes, flags ); % hirerchial clustering after pca
    ks(q) = CalcPercent( idx3, sizes, flags ); % kmeans clustering before pca
    kks(q) = CalcPercent( idx4, sizes, flags ); % kmeans clustering after pca
    o1s(q) = CalcPercent( opt1_idx, sizes, flags ); % optimal results ( best per kmeans out of 10) - after pca
    o2s(q) = CalcPercent( opt2_idx, sizes, flags ); % optimal results ( best per kmeans out of 10) - before pca
    % 1 - after pca (3 first dimentions)
    % 2 - before pca - all data    
    di1_s(q) = CalcPercent( di1_idx, sizes, flags );
    di2_s(q) = CalcPercent( di2_idx, sizes, flags );
    si1_s(q) = CalcPercent( si1_idx, sizes, flags );
    si2_s(q) = CalcPercent( si2_idx, sizes, flags );
    dbi1_s(q) = CalcPercent( dbi1_idx, sizes, flags );
    dbi2_s(q) = CalcPercent( dbi2_idx, sizes, flags );
    avg1_s(q) = CalcPercent( avg1_idx, sizes, flags );
    avg2_s(q) = CalcPercent( avg2_idx, sizes, flags );
    ss(q) = max(size(idx));
end

%%
figure('Name','cluster after pca 1:3 + dunns best of 10')
plot(xs,ys, '*')
xlabel('Bins Size');
ylabel('Success Percent');
ax = gca;
ax.YLim = [0 100];

% % 
% % figure('Name','cluster')
% % plot(xs,ys, '*')
% % xlabel('Bins Size');
% % ylabel('Success Percent');
% % ax = gca;
% % ax.YLim = [0 100];
% % figure('Name','cluster after pca')
% % plot(xs,as, '*')
% % xlabel('Bins Size');
% % ylabel('Success Percent');
% % ax = gca;
% % ax.YLim = [0 100];
% % figure('Name','kmeans')
% % plot(xs,ks, '*')
% % xlabel('Bins Size');
% % ylabel('Success Percent');
% % ax = gca;
% % ax.YLim = [0 100];
% % figure('Name','kmeans after pca')
% % plot(xs,kks, '*')
% % xlabel('Bins Size');
% % ylabel('Success Percent');
% % ax = gca;
% % ax.YLim = [0 100];
