import matplotlib.pyplot as plt
import numpy as np

COLORS = ['g','g','r','c','m','y','k']

class Grapher():
	def __init__(self, graph_rate):
		self.axs = None
		self.agents = []
		self.graph_rate = graph_rate
	def graphsHandler(self,num_graphs,graphs_dict):
		self.fig, self.axs = plt.subplots(num_graphs, sharex=True)
		i = 0
		for a in self.axs:
			a.set(xlabel= graphs_dict[i]['x'], ylabel= graphs_dict[i]['y'])
			i += 1
	def updateGraphs(self,graph_values):
		i = 0
		for a in self.axs:
			a.plot(graph_values[i][0], graph_values[i][1],'tab:red')
			i += 1
			plt.pause(self.graph_rate)
	def showGraphs(self,graph_values):
		i = 0
		for a in self.axs:
			a.plot(graph_values[i][0],graph_values[i][1],'tab:red')
			i += 1
		plt.show()

