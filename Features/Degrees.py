import networkx as nx
import numpy as np


def max_out_deg(graph):
	if graph.is_directed():
		out_deg = graph.out_degree().values()
	else:
		out_deg = graph.degree().values()
	return max(out_deg)


def avg_out_deg(graph):
	if graph.is_directed():
		out_deg = graph.out_degree().values()
	else:
		out_deg = graph.degree().values()
	return float(np.mean(out_deg))


def std_out_deg(graph):
	if graph.is_directed():
		out_deg = graph.out_degree().values()
	else:
		out_deg = graph.degree().values()
	return float(np.std(out_deg))


def distance_from_max_out_deg(graph):
	if graph.is_directed():
		out_deg = graph.out_degree().values()
	else:
		out_deg = graph.degree().values()
	lst = []
	max_deg = max(out_deg)
	for x in out_deg:
		lst.append(max_deg-x)
	return float(np.mean(lst))
