import random
import numpy as np
import initGraphS


def snapshots(file_name):
    """
    dictionary of graphs
    for each graph the function returns a dictionary of Ts,
    key: T, value: graph
    (creating the graph itself happends in the function singleSnapshot)
    """
    graph = initGraphS.init_Prob_graph(file_name, True)
    Ts = np.arange(0, 3, 0.01)
    dict = {}
    for T in Ts:
        g = singleSnapshot(graph, T)
        dict[T] = g
    return dict


def singleSnapshot(graph, T):
    """
    param: the basic graph, T-level of activation
    each edge gets a random probability (pi)
    then, we calculate weither the condition
    (if it is true, meaning the edges stays (on), or not, meaning we take the edge off)
    """
    snap = graph.copy()
    for edge in graph.edges(data='p_i'):
        x = random.uniform(0, 1)
        if T != 0:
            if x <= np.exp(-edge[2]/T):
                snap.remove_edge(edge[0], edge[1])
        else:
            if x <= 0:
                snap.remove_edge(edge[0], edge[1])
    return snap
