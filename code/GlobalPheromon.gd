extends Node2D

var matrix: Array = [] 
var min_x: int
var min_y: int
var max_x: int
var max_y: int

var timer = 0.0

func _ready() -> void:
	initialize_matrix(20,20)

func _process(delta: float) -> void:
	# Spawn enemy every second
	timer += delta
	if timer >= 3.0:
		timer = 0.0
		print_matrix()
		decrease_all_values(0.1)
		print_matrix()
		

# Initialise la matrice avec un centre (0,0) et des coordonnées correctes
func initialize_matrix(rows: int, cols: int, default_value = 0.0):
	matrix = []
	
	# Calcul des limites des coordonnées
	min_x = -rows / 2
	max_x = rows / 2 - 1
	min_y = -cols / 2
	max_y = cols / 2 - 1
	
	for i in range(rows):
		matrix.append([])
		for j in range(cols):
			matrix[i].append({
				"x": min_x + i,
				"y": min_y + j,
				"value": default_value
			})

# Augmente la valeur à une certaine coordonnée (x, y)
func increase_value(x: int, y: int, amount: int = 1):
	if is_within_bounds(x, y):
		matrix[x][y]["value"] += amount
	else:
		print("Erreur: Coordonnées hors limites")

# Diminue la valeur de toutes les coordonnées sans descendre en dessous de 0
func decrease_all_values(amount: int = 1):
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			matrix[i][j]["value"] = max(0, matrix[i][j]["value"] - amount)

# Vérifie si les coordonnées (x, y) sont bien dans la matrice
func is_within_bounds(x: int, y: int) -> bool:
	return x >= min_x and x <= max_x and y >= min_y and y <= max_y

# Affiche la matrice dans la console (pour le debug)
func print_matrix():
	for row in matrix:
		print(row)
