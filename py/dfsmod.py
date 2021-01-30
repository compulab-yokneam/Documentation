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

	# function to add an edge to graph
	def addEdge(self, u, v):
		self.graph[u].append(v)

	# A function used by DFS
	def DFSUtil(self, v):

		# Mark the current node as visited
		self.visited.add(v)

		# Recur for all the vertices
		# adjacent to this vertex
		for neighbour in self.graph[v]:
			# Add each node that points to this neighbour
			self.links[neighbour].append(v)
			if neighbour not in self.visited:
				self.DFSUtil(neighbour)

	# The function to do DFS traversal.
	# It uses recursive DFSUtil()
	def DFS(self, v):

		# Create a set to store visited vertices
		# Call the recursive helper function
		# to print DFS traversal
		self.DFSUtil(v)

		print('Dependencies: ', self.links, end='\n')

# Create a graph given
# in the above diagram
g = Graph()
g.addEdge(0, 1)
g.addEdge(0, 2)
g.addEdge(1, 2)
g.addEdge(2, 0)
g.addEdge(2, 3)
g.addEdge(3, 3)

v=0
print("Following is DFS from (starting from vertex", v)
g.DFS(v)
