import networkx as nx
import scipy as sp
#import numpy.linalg as LA


def maxEigenValues(G):
    A = nx.adjacency_matrix(G)
    eigVals = sp.linalg.eigvals(A.todense())
    return max(abs(eigVals))


def minEigenValues(G):
    A = nx.adjacency_matrix(G)
    eigVals = sp.linalg.eigvals(A.todense())
    return min(abs(eigVals))

#for Laplacian
def laplacian_max_eigenValues(graph):
    A = nx.laplacian_matrix(nx.Graph(graph))
    eigVals = sp.linalg.eigvals(A.todense())
    return max(abs(eigVals))


def laplacian_min_eigenvalues(graph):
    A = nx.laplacian_matrix(nx.Graph(graph))
    eigVals = sp.linalg.eigvals(A.todense())
    return min(abs(eigVals))
