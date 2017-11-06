import networkx as nx

from networkx.algorithms.shortest_paths import weighted as weight

"""
maximum flow value:  Find the value of maximum single-commodity flow.
sum over all the nodes
"""
def FlowSum(graph):
    sum=0
    #wanted to count only the vertix that has a path, another option is using the method "has_path"
    flowDict=nx.all_pairs_shortest_path_length(graph)
    for source in flowDict.keys():
        for target in (flowDict[source]).keys():
                sum+=nx.maximum_flow_value(graph,source,target)
    return sum/2

def MaxFlow(graph):
    max=0
    #wanted to count only the vertix that has a path, another option is using the method "has_path"
    flowDict=nx.all_pairs_shortest_path_length(graph)
    for source in flowDict.keys():
        for target in (flowDict[source]).keys():
            flow=nx.maximum_flow_value(graph,source,target)
            if(flow > max ):
                    max=flow
    return max/2 #counts twice

def AverageFlow(graph):
    sum=0
    #wanted to count only the vertix that has a path, another option is using the method "has_path"
    flowDict=nx.all_pairs_shortest_path_length(graph)
    for source in flowDict.keys():
        for target in (flowDict[source]).keys():
                sum+=nx.maximum_flow_value(graph,source,target)
    return sum/(2*nx.number_of_nodes(graph))


"""
#from master:
def flow_mesure( gnx,threshold):


    flow_map = calculate_flow_index(gnx,threshold)

    #for n in flow_map:
    #    f.writelines(str(n)+','+str(flow_map[n]) + '\n')

    return flow_map


def calculate_flow_index(gnx,threshold):
    flow_list = {}
    nodes = gnx.nodes()
    gnx_without_direction=gnx.to_undirected()
    max_b_v = 0;
    for n in nodes:
        b_v = len(nx.ancestors(gnx_without_direction, n))
        if (b_v > max_b_v):
            max_b_v = b_v
    for n in nodes:
        b_u = len(nx.ancestors(gnx_without_direction,n))
        frac_but=weight.all_pairs_dijkstra_path_length(gnx, b_u, weight='weight')
        frac_top=weight.all_pairs_dijkstra_path_length(gnx_without_direction, b_u, weight='weight')
        vet_sum = 0
        for k in nodes:
            if (k in frac_but[n]):
                if (frac_but[n][k] != 0 and float(b_u)/max_b_v > threshold):
                    vet_sum+=frac_top[n][k]/frac_but[n][k]
        flow_node = float(vet_sum)/b_u
        flow_list[n] = flow_node

    return flow_list
"""