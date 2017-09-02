#importiere notwendige Packages
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import sys

#initialisiere globale Berechnungsvariablen
dataset = []
k = 1

def printBarPlot():
	print('Hier 3D-Vusualisierung einfügen')

if __name__ == "__main__":
	#setze Parameter des ABOD-Algorithmus nach User-Input, wenn dieser vollständig ist
	if(len(sys.argv) < 3):
		print('Gebe den Dateipfad zum Datensatz und k als Parameter ein!')
		exit(0)

	k = int(sys.argv[2])
	dataset = np.genfromtxt(sys.argv[1], delimiter=',')
	dataset = np.delete(dataset,0,0)

	#Berechnungslogik für Ermittlung des ABOD(p) für alle Punkte p aus dataset bzgl. k-Nachbarn
	#k-Nachbarschaft eines jeden Punktes ermitteln
	#dann ABOD-Definition anwenden
	
	#Visualsierung der ABOD-Werte pro Punkt
	printBarPlot()