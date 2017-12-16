1. the program ran 10 times clustering
chose the best cluster by criterion:
si - highest silhouette
di - highest dunns index
dbi - lowest Davies Bouldin index
avg - highest average between si and di
optimal - best percent acuracy (gives indication to how well we can get from the data, with the best clustering)

2. after pca: clustering on first 3 dimentions of pca over the data
before pca: original data

3. log(samples): 
y label - success percent of the clustering
x label - log over the amount of samples tested

4. dunns index implementation taken from: https://www.mathworks.com/matlabcentral/fileexchange/27859-dunn-s-index
