import networkx as nx
import matplotlib as plt

def smallworld(graph):
    #according defenition
    distance=0
    paths=0
    #all the pairs of nodes that are connected
    dict1=nx.shortest_path(graph)
    for source in dict1.keys():
        for target in dict1[source].keys():
            paths+=1
            distance += len(dict1[source][target])
    smallworld=distance/paths

    #in addition we added this section to tell us weither the graph is connected
    """
    if( nx.number_weakly_connected_components(graph)>1 ):
        print 'not connected'
    elif(nx.number_strongly_connected_components(graph)==1):
        'strongly_connected'
    else:
        print 'weakly_connected but not strongly_connected'
    """
    return smallworld
