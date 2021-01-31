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
        self.visited1 = set()

    # function to add an edge to graph
    def addedge(self, u, v):
        self.graph[u].append(v)

    # A function used by dfs
    def dfsutil(self, v):

        # Mark the current node as visited
        self.visited.add(v)

        # Recur for all the vertices
        # adjacent to this vertex
        for neighbour in self.graph[v]:
            # Add each node that points to this neighbour
            self.links[neighbour].append(v)
            if neighbour not in self.visited:
                self.dfsutil(neighbour)

    # The function to do dfs traversal.
    # It uses recursive dfsutil()
    def dfs(self, v):

        # Create a set to store visited vertices
        # Call the recursive helper function
        # to print dfs traversal
        self.dfsutil(v)

        print('Graph       : ', self.graph, end='\n')
        print('Dependencies: ', self.links, end='\n')

    def dfs1(self, v):
        self.visited1.add(v)
        for neighbour in self.links[v]:
            if neighbour not in self.visited1:
                self.dfs1(neighbour)
                print(neighbour, end=' ')


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

global v

v = 2
print("Following is dfs from (starting from vertex", v)
g.dfs(v)

v = 3
print("Update node order for:", v)
g.dfs1(v)
