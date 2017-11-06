import networkx as nx

from networkx.algorithms.shortest_paths import weighted as weight

"""
file can be delited, all functions were moved and improved in file Flow
"""
def FlowSum(graph):
    sum=0
    flow_list=flow_mesure(graph, 0)
    for v in flow_list:
        sum=sum+flow_list[v]
    return sum


def FlowAverage(graph):
    sum=FlowSum(graph)
    n=len(flow_list)
    return sum/n


#from master:
def flow_mesure(gnx, threshold):
    flow_map = calculate_flow_index(gnx, threshold)

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
