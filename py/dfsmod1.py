from collections import defaultdict


class Graph:

    # Constructor
    def __init__(self):
        # default dictionary to store graph
        self.graph = defaultdict(list)
        # this list is for saving the linked from vertex
        self.links = defaultdict(list)
        # this set is for visited vertex
        self.visited = set()

        self.back_visited = set()
        self.dep = defaultdict(list)

    # function to add an edge to graph
    def addedge(self, u, v):
        self.graph[u].append(v)

    # A function used by dfs
    def dfsutil(self, _v):

        # Mark the current node as visited
        self.visited.add(_v)

        # Recur for all the vertices
        # adjacent to this vertex
        for neighbour in self.graph[_v]:
            # Add each node that points to this neighbour
            self.links[neighbour].append(_v)
            if neighbour not in self.visited:
                self.dfsutil(neighbour)

    # The function to do dfs traversal.
    # It uses recursive dfsutil()
    def dfs(self, _v):

        self.dfsutil(_v)

        print('Graph       : ', self.graph, end='\n')
        print('Dependencies: ', self.links, end='\n')

    def dfsbackutil(self, _v):
        self.back_visited.add(_v)
        for neighbour in self.links[_v]:
            if neighbour not in self.back_visited:
                self.dfsbackutil(neighbour)
                self.dep[v].append(neighbour)

    def dfsback(self, _v):
        self.dfsbackutil(_v)
        print('Dependenies of: ', v, self.dep, end='\n')


g = Graph()
g.addedge(2, 1)

# Loop 2->7->2
g.addedge(2, 7)
g.addedge(7, 2)

# loop back 7->7
g.addedge(7, 7)

g.addedge(7, 5)
g.addedge(2, 3)
g.addedge(1, 3)
g.addedge(2, 4)
g.addedge(2, 5)
g.addedge(5, 6)
g.addedge(6, 3)

v = 2
print("Following is dfs from (starting from vertex", v)
g.dfs(v)

v = 3
print("Update node order for:", v)
g.dfsback(v)
