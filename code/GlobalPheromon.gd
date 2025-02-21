extends Node2D
var matrix: Array = [] 

func initialize_matrix(rows: int, cols: int, default_value = 0):
	matrix = []
	for i in range(rows):
		matrix.append([])
		for j in range(cols):
			matrix[i].append(default_value)
