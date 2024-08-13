import matplotlib.pyplot as plt
import numpy as np

COLORS = ['g','g','r','c','m','y','k']

class Grapher():
	def __init__(self):
		self.axs = None
		self.agents = []
		self.graph_rate = 0.01
	def graphsHandler(self,num_graphs,graphs_dict):
		self.fig, self.axs = plt.subplots(num_graphs, sharex=True)
		i = 0
		for a in self.axs:
			a.set(xlabel= graphs_dict[i]['xlab'],ylabel= graphs_dict[i]['ylab'])
			i += 1
	def setGraphRate(self,dt):
		self.graph_rate = dt
	def setGraphColors(self):
		pass
	def updateGraphs(self,graph_values):
		i = 0
		for a in self.axs:
			a.plot(graph_values[i][0],graph_values[i][1],'tab:red')
			i += 1
			plt.pause(self.graph_rate)
	def showGraphs(self,graph_values,batch_num = 0):
		i = 0
		for a in self.axs:
			a.plot(graph_values[i][0],graph_values[i][1],'tab:red')
			i += 1
		plt.show()

if __name__ == "__main__":
	graph_labels = {"xlab" : "xlab", "ylab" : "ylab", "title" : "Title"}
	graph_labels2 = {"xlab" : "xlab2", "ylab" : "ylab2", "title" : "Title2"}
	graphs_dict = [graph_labels,graph_labels2]
	g = GraphicHandler()
	g.graphsHandler(2,graphs_dict)
	x1 = []
	y1 = []
	x2 = []
	y2 = []
	for i in range(10):
		x1.append(i)
		y1.append(i)
		y2.append(i)
		x2.append(i)
		graph_values = [(x1,y1),(x2,y2)]
		g.updateGraphs(graph_values)# -*- coding: utf-8 -*-
"""
Created on Sat Jul 13 22:34:28 2024

@author: Eugene
"""

