import networkx as nx
import numpy as np
"""
import ReadFeatureFileS.py
from Queue import *

def NumDirectedMotifs(file, n=None):
    if n==None:
        n=3
    verticesDict=ReadFeatureFileS.fileToMap_vertices(file)
    numOfDM=0
    for currVertice in verticesDict.key():
        k=0
        BFS=Queue(verticesDict[currVertice])
        while k<n:
            size=BFS.qsize()
            for i in size:
                v=BFS.popleft()
                BFS.extend(verticesDict(v))
            k+=1

        size=BFS.qsize()
        for i in size:
            if BFS.popleft() ==currVertice:
                numOfDM +=1
    numOfDM=numOfDM/n
    return numOfDM


def NumGeneralMotifs(file, n=None):
    if n==None:
        n=3
    verticesRDict=ReadFeatureFileS.fileToMap_ReversedVertices(file)
    verticesDict=ReadFeatureFileS.fileToMap_vertices(file)
    numOfDM=0

    for currVertice in verticesDict.key():
        k=1
        set=set()
        set.add(currVertice)
        BFS= Queue()
        for neighbor in verticesDict[currVertice]:
            set.add(neighbor)
            BFS.put(neighbor)
        for neighbor in verticesRDict[currVertice]:
            set.add(neighbor)
            BFS.put(neighbor)

        while k<n:
            size=BFS.qsize()
            for i in size:
                v=BFS.get()
                if v not in set:
                    set.add(v)
                    for neighbor in verticesDict[v]:
                        if neighbor not in set:
                            set.add(neighbor)
                            BFS.put(neighbor)
                    for neighbor in verticesRDict[v]:
                        if neighbor not in set:
                            set.add(neighbor)
                            BFS.put(neighbor)
            k+=1

        while not BFS.empty():
            for neighbor in verticesDict[BFS.get()]:
                if neighbor ==currVertice:
                    numOfDM +=1

    numOfDM=numOfDM/n

    return numOfDM
"""


def motif_n(graph, n = 3):
    a = nx.to_numpy_matrix(graph)
    m, k = a.shape
    a_n = np.eye(m)
    for i in range(n):
        a_n = np.dot(a_n, a)

    b = nx.to_numpy_matrix(nx.Graph(graph))
    b_n = np.eye(m)
    for i in range(n):
        b_n = np.dot(b_n, b)

    motifs_size_n = np.trace(a_n)
    motifs_size_n_non_dir = np.trace(b_n)

    if motifs_size_n_non_dir != 0:
        return float(motifs_size_n)/float(motifs_size_n_non_dir)
    else:
        return -0.1
