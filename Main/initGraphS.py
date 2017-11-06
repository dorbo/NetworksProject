import networkx as nx  # import utils.gnxToGgt as ut
import matplotlib.pyplot as plt  # import os
import random


def init_Prob_graph(file_name, directed):
    """
    initializes the graph with using networkx packege
    :param draw: boolean parameter- True if we want to draw the graph otherwise - False
    :param file_name: the name of the file that contains the edges of the graph
    :param directed: boolean parameter- True if the graph is directed otherwise - False
    :return: nx.Graph or nx.DiGraph in accordance with the 3rd param
    """

    if directed:
        G = nx.DiGraph()
    else:
        G = nx.Graph()
    with open(file_name, 'r') as f:
        for line in f:
            a = line.split()
            G.add_edge(a[0], a[1], {'p_i': random.uniform(0, 1)})  # 'weight': float(a[8]),
    return G
