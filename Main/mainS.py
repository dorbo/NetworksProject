import glob
import CreatingProbabilityGraph
import SnapshotsByBinsSize
# import CreatingProbabilityGraph2
import sys
import os
sys.path.append('../')
from Features import eigenValues
from Features import nilpotentDeg
from Features import motifsN
from Features import AvaregeDegree
from Features import connectedComponents
from Features import density
from Features import laplacian
from Features import Flow
from Features import betweenness
from Features import smallworld
from Features import Degrees
# from Features import flow_Sum_Average
# import matplotlib.pyplot as plt

"""
mainS runs at all graphs and calculates all the features,
writes the results in .txt files
"""


def main_all_graphs():
	strbeggin = '../TData/'
	strendfilename = '_data'


	# features to calculate
	featuresList = [motifsN.motif_n, eigenValues.maxEigenValues,
					eigenValues.laplacian_max_eigenValues,
					AvaregeDegree.average_degree, connectedComponents.numOfConnectedComponents,
					connectedComponents.max_size_cc, connectedComponents.avg_nodes_in_cc,
					connectedComponents.avg_shortest_path_in_cc, connectedComponents.diameter,
					connectedComponents.avg_clustering, connectedComponents.transitivity, density.density,
					AvaregeDegree.degree_centrality, betweenness.betweenness, betweenness.betweenness_normalized,
					betweenness.edge_betweenness, smallworld.smallworld, Degrees.max_out_deg,
					Degrees.avg_out_deg, Degrees.std_out_deg, Degrees.distance_from_max_out_deg]

	# featuresList = [eigenValues.laplacian_min_eigenvalues, eigenValues.minEigenValues]

	# reading all graph names from the data/graphs folder
	graph_names = glob.glob("../data/graphs/allgraphs/*.txt")

	# correcting the dir of the graphs - \ /
	for i in range(0, len(graph_names)):
		graph_names[i] = graph_names[i].replace('\\', '/')

	for graph in graph_names:
		# creating probability graph & snapshots
		graph_snapshots = CreatingProbabilityGraph.snapshots(graph)
		str = strbeggin + graph[22:(len(graph)-4)] + strendfilename
		print str
		# creating folder if not exist
		try:
			os.makedirs(str)
		except OSError:
			pass

		Ts = sorted(graph_snapshots.keys())
		for feature in featuresList:
			str = strbeggin + graph[22:(len(graph)-4)] + strendfilename

			res = []
			for T in Ts:
				res.append(feature(graph_snapshots[T]))

			str = str + '/' + feature.__name__ + '_data.txt'

			f = open(str, 'w')
			f.writelines(['%f ' % num for num in res])
			f.close()


def main_DepData_graphs():
	bins = range(1000, 1000999, 2000)
	# features to calculate
	featuresList = [motifsN.motif_n, eigenValues.maxEigenValues,
					eigenValues.laplacian_max_eigenValues,
					AvaregeDegree.average_degree, connectedComponents.numOfConnectedComponents,
					connectedComponents.max_size_cc, connectedComponents.avg_nodes_in_cc,
					connectedComponents.avg_shortest_path_in_cc, connectedComponents.diameter,
					connectedComponents.avg_clustering, connectedComponents.transitivity, density.density,
					AvaregeDegree.degree_centrality, betweenness.betweenness, betweenness.betweenness_normalized,
					betweenness.edge_betweenness, smallworld.smallworld, Degrees.max_out_deg,
					Degrees.avg_out_deg, Degrees.std_out_deg, Degrees.distance_from_max_out_deg]

	# featuresList = [eigenValues.laplacian_min_eigenvalues, eigenValues.minEigenValues]

	for bins_size in bins:
		strbeggin = '../SecData/bins_size_' + str(bins_size) + '_data/'
		strendfilename = '_data'

		# reading all graph names from the data/graphs folder
		graph_names = glob.glob("../data/graphs/DepData/*.txt")

		# correcting the dir of the graphs - \ /
		for i in range(0, len(graph_names)):
			graph_names[i] = graph_names[i].replace('\\', '/')

		for graph in graph_names:
			# creating probability graph & snapshots
			graph_snapshots = SnapshotsByBinsSize.snapshots(graph, bins_size)
			fullstr = strbeggin + graph[22:(len(graph)-4)] + strendfilename

			# creating folder if not exist
			try:
				os.makedirs(fullstr)
			except OSError:
				pass

			Ts = sorted(graph_snapshots.keys())
			for feature in featuresList:
				fullstr = strbeggin + graph[22:(len(graph)-4)] + strendfilename

				res = []
				for T in Ts:
					res.append(feature(graph_snapshots[T]))

				fullstr = fullstr + '/' + feature.__name__ + '_data.txt'

				f = open(fullstr, 'w')
				f.writelines(['%f ' % num for num in res])
				f.close()

main_all_graphs()
