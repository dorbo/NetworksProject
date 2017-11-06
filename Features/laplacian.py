import networkx as nx
import matplotlib.pyplot as plt
import numpy as np

def lapSpec (graphDic):
    t_list=np.array([])
    eigenval_list=np.array([])
    #for each t all its eigenvalus (eg) in a parallel list
    for T in graphDic.keys():
        graph=(graphDic[T]).to_undirected()
        for ev in np.nditer(nx.laplacian_spectrum(graph)):
            t_list=np.append(t_list, T)
            eigenval_list=np.append( eigenval_list , ev)

    #draw
    plt.plot(t_list, eigenval_list,'ro')
    plt.show()
    return 1

def algebraic_connectivity(graph):#no strong connected components!!!
    #This eigenvalue is greater than 0 if and only if G is a connected graph.
    # This is a corollary to the fact that the number of times 0 appears as an eigenvalue in the Laplacian
    # is the number of connected components in the graph.
    #wikipedia

    #cc for conected components
    #ac_list for all of their ac's
    g_list=[]
    totalsum=0
    cc = nx.strongly_connected_component_subgraphs(graph)
    for g in cc:
        if nx.number_of_nodes(g)>2:
            udg=g.to_undirected()
            weighted = (nx.algebraic_connectivity(udg))*(udg.number_of_edges())
            g_list.append(weighted)
            totalsum=totalsum+g.size()
    average = sum(g_list)/totalsum
    return average


