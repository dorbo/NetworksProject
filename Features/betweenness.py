import networkx as nx

def betweenness(graph):
    max = 0
    dict=nx.betweenness_centrality(graph, None,True)
    for v in dict.values():
        if max<v:
          max = v
    return max

def betweenness_normalized(graph): #normilized??
    max=0
    dict=nx.load_centrality(graph)
    for v in dict.values():
        if max<v:
          max=v
    return max

def edge_betweenness(graph):
    #returns the maximum of edge_betweenness_centrality
    max=0
    dict=nx.edge_betweenness_centrality(graph,True)
    for v in dict.values():
        if max<v:
          max=v
    return max