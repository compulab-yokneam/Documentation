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

		print('Graph       : ', self.graph, end='\n')
		print('Dependencies: ', self.links, end='\n')

	def DFSUtil1(self, v):
		self.visited1.add(v)
		for neighbour in self.links[v]:
			if neighbour not in self.visited1:
				self.DFSUtil1(neighbour)
				print(neighbour, end=' ')

	def DFS1(self, v):
		self.DFSUtil1(v)


# Create a graph given
# in the above diagram
g = Graph()
g.addEdge(2, 1)

g.addEdge(2, 7)
g.addEdge(7, 5)

g.addEdge(7, 7)

g.addEdge(2, 3)
g.addEdge(1, 3)
g.addEdge(2, 4)
g.addEdge(2, 5)
g.addEdge(5, 6)
g.addEdge(6, 3)

v=2
print("Following is DFS from (starting from vertex", v)
g.DFS(v)

v=3
print("Update node order for:", v)
g.DFS1(v)
