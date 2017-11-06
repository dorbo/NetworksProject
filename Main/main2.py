import CreatingProbabilityGraph
import matplotlib.pyplot as plt
import sys

sys.path.append('../')
from Features import AvaregeDegree



"""
this file is for tests or specific features.
in plotF we choose a graph and it canculates the given feature
in allgraph runs at all the graphs and canculates the given feature
"""


def plotF():
    graph_name = '../data/graphs/sample/19800.dat'

    """
    the function "CreatingProbabilityGraph"  return a dictionary of the samples of the graph
    keys: T between (0,3)
    values: a sample of the the graph, for that given T
    """
    dictSnapshots = CreatingProbabilityGraph.snapshots(graph_name)
    fig = plt.figure()
    ax1 = fig.add_subplot(1, 1, 1)

    Ts = sorted(dictSnapshots.keys())
    res = []

    #canculating the feature and insert the value to a vector
    for T in Ts:
        res.append(AvaregeDegree.average_degree(dictSnapshots[T]))

    #draw the results
    ax1.clear()
    ax1.plot(Ts, res)
    plt.show()




def allgraphs():
    # all graphs:
    graph_name1 = '../data/graphs/allgraphs/signaling_pathways_2004.txt'
    graph_name2 = '../data/graphs/allgraphs/signaling_pathways_2006.txt'
    """
    the function "CreatingProbabilityGraph"  return a dictionary of the samples of the graph
    keys: T between (0,3)
    values: a sample of the the graph, for that given T
    """
    dictSnapshots1 = CreatingProbabilityGraph.snapshots(graph_name1)
    dictSnapshots2 = CreatingProbabilityGraph.snapshots(graph_name2)

    Ts = sorted(dictSnapshots1.keys())
    res1 = []
    res2 = []

    #canculating the feature and insert the value to a vector
    for T in Ts:
        res1.append(AvaregeDegree.average_degree(dictSnapshots1[T]))
        res2.append(Flow.MaxFlow(dictSnapshots2[T]))

    #draw the results
    plt.subplot(211)
    plt.plot(Ts, res1)
    plt.subplot(212)
    plt.plot(Ts, res2)
    plt.show()


def pergraph(graph_name):
    dictSnapshots = CreatingProbabilityGraph.snapshots(graph_name)

    fig = plt.figure()
    ax1 = fig.add_subplot(1, 1, 1)

    Ts = sorted(dictSnapshots.keys())
    res = []

    #canculating the feature and insert the value to a vector
    for T in Ts:
        res.append(AvaregeDegree.average_degree(dictSnapshots[T]))

    #draw the results
    ax1.clear()
    ax1.plot(Ts, res)
    plt.show()



plotF()

