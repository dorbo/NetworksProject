import glob
import sys
sys.path.append('../')
import networkx as nx

def main():
	file_name = '../data/graphs/allgraphs/signaling_pathways_2006.txt'
	G = nx.DiGraph()
	with open(file_name, 'r') as f:
		for line in f:
			a = line.split()
			G.add_edge(a[0], a[1])
	print 'edges: ', G.number_of_edges()
	print 'nodes: ', G.number_of_nodes()

main()
