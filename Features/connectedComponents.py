import networkx as nx


def numOfConnectedComponents(graph):
	cc = nx.strongly_connected_components(graph)
	return len(list(cc))


def max_size_cc(graph):
	cc = nx.strongly_connected_component_subgraphs(graph)
	arr = [-1]
	for g in cc:
		arr.append(nx.number_of_nodes(g))
	return max(arr)


def avg_nodes_in_cc(graph):
	cc = nx.strongly_connected_component_subgraphs(graph)
	sum_n = 0
	num_of_nodes = 0
	for g in cc:
		num = nx.number_of_nodes(g)
		sum_n = sum_n + num * num
		num_of_nodes = num_of_nodes + num
	if num_of_nodes == 0:
		return -1
	else:
		return sum_n/num_of_nodes


def avg_shortest_path_in_cc(graph):
	cc = nx.strongly_connected_component_subgraphs(graph)
	sum = 0
	num_of_nodes = 0
	for g in cc:
		if nx.number_of_nodes(g) != 1:
			sum = sum + nx.number_of_nodes(g) * nx.average_shortest_path_length(g)
			num_of_nodes = num_of_nodes + nx.number_of_nodes(g)
		else:
			sum = sum + 0
			num_of_nodes = num_of_nodes + 1

	if num_of_nodes == 0:
		return -1
	else:
		return sum/num_of_nodes


def diameter(graph):
	cc = nx.strongly_connected_component_subgraphs(graph)
	arr = [-1] #default
	for g in cc:
		arr.append(nx.diameter(g))
	return max(arr)


def avg_clustering(graph):
	return nx.average_clustering(nx.Graph(graph))


def transitivity(graph):
	return nx.transitivity(graph)
