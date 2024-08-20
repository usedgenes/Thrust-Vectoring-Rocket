import matplotlib.pyplot as plt
import numpy as np

COLORS = ['g','g','r','c','m','y','k']

class Grapher():
    def __init__(self):
        self.fig = None
        self.axs = None
        self.agents = []
        plt.close('all')
    def graphsHandler(self,num_graphs,graphs_dict):
        self.fig, self.axs = plt.subplots(num_graphs, sharex=False)
        i = 0
        for a in self.axs:
            a.set(xlabel= graphs_dict[i]['x'], ylabel= graphs_dict[i]['y'])
            i += 1
    def updateGraphs(self,graph_values):
        i = 0
        for a in self.axs:
            a.plot(graph_values[i][0], graph_values[i][1],'tab:red')
            i += 1
    def showGraphs(self,graph_values):
        i = 0
        for a in self.axs:
            a.plot(graph_values[i][0],graph_values[i][1],'tab:red')
            i += 1
        manager = plt.get_current_fig_manager()
        manager.window.showMaximized()
        plt.show()

if __name__ == "__main__":
    graph_labels = {"x" : "x", "y" : "y", "title" : "Title"}
    graph_labels2 = {"x" : "xlab2", "y" : "ylab2", "title" : "Title2"}
    graphs_dict = [graph_labels,graph_labels2]
    g = Grapher()
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
        g.updateGraphs(graph_values)