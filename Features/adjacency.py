import networkx as nx
import matplotlib.pyplot as plt
import numpy as np



def adjSpec(graphDic):
    """
    for each base graph, we take all of its samples and canculate for each one its eigenvalue of its adjacency matrix
    draws a graph were :
        the vertical axis is the graphs (according their Ts),
        the horizontal axis there are the eigenvalues.
        each graph (usually) has more than one eigenvalue, which are represented by dots
    :param graphDic: dictionary of a base graph with the samples ( key: T, value:graph )
    :return:nothing. draws .
    """

    t_list=np.array([])
    eigenval_list=np.array([])
    #for each t all its eigenvalues (eg) in a parallel list
    for T in graphDic.keys():
        for ev in np.nditer(nx.adjacency_spectrum(graphDic[T])):
            t_list=np.append(t_list, T)
            eigenval_list=np.append(eigenval_list, ev)

    #draw
    plt.plot(t_list, eigenval_list, 'ro')
    plt.show
    return 1
