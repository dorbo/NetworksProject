import networkx as nx
import numpy as np


def nilpotentDeg(graph):

    a = nx.to_numpy_matrix(graph)
    #size of matrix
    n, k = a.shape
    a_i = a
    #computing each product and checking if the matrix is 0
    for i in range(n):
        if np.all(a_i == 0):
            return i + 1
        a_i = np.dot(a_i, a)
    return -1

"""
#Laplacian Nilpotent Deg
def laplacian_nilpotent_deg(graph):
    a = nx.laplacian_matrix(graph)
    a = a.todense()
    n, k = a.shape
    a_i = a
    for i in range(n):
        if np.all(a_i == 0):
            return i + 1
        a_i = np.dot(a_i, a)
    return -1
"""
