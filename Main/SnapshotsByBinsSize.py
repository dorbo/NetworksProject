import networkx as nx
import math

def snapshots(file_name, bins_size):
	"""
	dictionary of dictionary
	for each graph the function returns a dictionary of Ts,
	each T is actually a dictionary of graphs with the same T
	note the graphs will still be different. The porpuse is avarage.
	"""

	file = open(file_name)
	lines = file.readlines()
	(v1, v2, max_time) = lines[-1].split()


	dict = {}

	j = 0

	for i in range(1, int(math.ceil(float(max_time)/bins_size))+1):
		# g = singleSnapshot((i-1)*bins_size, i*bins_size, file_name)

		beg = (i - 1) * bins_size
		end = i * bins_size
		snap = nx.DiGraph()
		size = 0
		flag = True

		while flag and j < len(lines):
			(u, v, time) = lines[j].split()
			if beg < float(time) <= end:
				snap.add_edge(u, v)
				size += 1
			if float(time) <= end:
				j = j + 1
			if float(time) > end:
				flag = False
		if size != 0:
			dict[i] = snap
	return dict


def singleSnapshot(beg, end, file_name):
	snap = nx.DiGraph()

	with open(file_name) as f:
		for line in f:
			(u, v, time) = line.split()
			if beg < float(time) <= end:
				snap.add_edge(u, v)
			if float(time) > end:
				break

	return snap
