import networkx as nx


def average_degree(graph):
	#the function below returns A dictionary keyed by degree k with the value of average connectivity.
	dict = nx.average_degree_connectivity(graph)
	num_of_nodes = 0
	sum_of_deg = 0

	for key in dict.keys():
		sum_of_deg = sum_of_deg + key * dict[key]
		num_of_nodes = num_of_nodes + dict[key]

	if num_of_nodes == 0:
		return -1
	else:
		return sum_of_deg/num_of_nodes


def degree_centrality(graph):
	maxv=0
	sum=0
	#A dictionary with nodes as keys and degree as values or a number if a single node is specified.
	degdict=graph.degree(None, 'weight')
	for v in degdict:
		vdeg=graph.degree(v,'weight')
		sum+=vdeg
		if maxv < vdeg:
		    maxv=vdeg
	sum=sum-maxv
	#from wikipidia:
	degreecentrality=nx.number_of_nodes(graph)*maxv-sum
	return degreecentrality
