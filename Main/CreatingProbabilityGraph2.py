import networkx as nx


def snapshots(file_name):
	"""
	dictionary of dictionary
	for each graph the function returns a dictionary of Ts,
	each T is actually a dictionary of graphs with the same T
	note the graphs will still be different. The porpuse is avarage.
	"""
	Ts = []
	with open(file_name) as f:
		for line in f:
			(v1, v2, time) = line.split()
			Ts.append(float(time))
	Ts = sorted(Ts)
	dict = {}
	for T in Ts:
		g = singleSnapshot(T, file_name)
		dict[T] = g
	return dict


def singleSnapshot(T, file_name):
	"""
	:param T: specific second for each snapshot 
	:param file_name: direction of the graph file
	:return: snapshot of the graph in time T
	"""
	snap = nx.DiGraph()
	size = 0
	with open(file_name) as f:
		for line in f:
			(u, v, time) = line.split()
			if time == T:
				size += 1
				snap.add_edge(u, v)
	return snap
