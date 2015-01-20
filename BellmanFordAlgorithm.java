import java.util.Arrays;
import java.util.Vector;

public class BellmanFordAlgorithm {
	public static int infinity = Integer.MAX_VALUE;

	//constructor of edges between nodes
	//set variables for source, destination, and weight
	//construct edge with source, destination, weight params
	static class Edge {
		int sourceNode; 
		int destinationNode; 
		int weightOfEdge; 
		public Edge() {}; 
		public Edge(int source, int destination, int weight) { sourceNode = source; destinationNode = destination; weightOfEdge = weight; }
	}

	
	//algorithm to calc shortest path and display results
	public static void bellmanFordAlgorithm(Vector<Edge> edges, int numberOfNodes, int source) 
	{
		int[] distance = new int[numberOfNodes];
		Arrays.fill(distance, infinity);
		distance[source] = 0;
		for (int i = 0; i < numberOfNodes; ++i)
			for (int j = 0; j < edges.size(); ++j) {

				if (distance[edges.get(j).sourceNode] == infinity) continue;

				int newDistance = distance[edges.get(j).sourceNode] + edges.get(j).weightOfEdge;

				if (newDistance < distance[edges.get(j).destinationNode])
					distance[edges.get(j).destinationNode] = newDistance;
			}

		for (int i = 1; i < distance.length; ++i)
			if (distance[i] == infinity)
				System.out.println("No path between " + source + " and " + i);
			else
				System.out.println("The shortest distance between nodes " + source + " and " + i + " is " + distance[i]);
	}

	public static void main(String[] args) {
		Vector<Edge> edges = new Vector<Edge>(); 
		edges.add(new Edge(5, 3, 4));
		edges.add(new Edge(5, 4, 1));
		edges.add(new Edge(5, 2, 2));
		edges.add(new Edge(5, 1, 2));
		edges.add(new Edge(5, 6, 4));
		edges.add(new Edge(5, 1, 4));
		edges.add(new Edge(5, 4, 2));
		edges.add(new Edge(5, 5, 4));
		edges.add(new Edge(5, 1, 1));
		edges.add(new Edge(5, 3, 2));
		edges.add(new Edge(5, 6, 2));
		edges.add(new Edge(5, 3, 4));
		edges.add(new Edge(5, 6, 3));
		edges.add(new Edge(5, 5, 3));
		edges.add(new Edge(5, 4, 2));
		edges.add(new Edge(5, 2, 4));
		bellmanFordAlgorithm(edges, 7, 5);
	}
}