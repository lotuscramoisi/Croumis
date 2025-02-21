extends Node2D

var matrix: Array = [] 
var min_x: int
var min_y: int
var max_x: int
var max_y: int

var timer = 0.0

func _ready() -> void:
	initialize_matrix(20, 20)  # Initialisation de la matrice avec les coordonnées

func _process(delta: float) -> void:
	# Timer pour exécuter l'action toutes les 3 secondes
	timer += delta
	if timer >= 3.0:
		timer = 0.0
		print_matrix()  # Afficher la matrice
		decrease_all_values(0.1)  # Diminuer la valeur de toutes les coordonnées
		print_matrix()  # Afficher la matrice après diminution

# Initialise la matrice avec un centre (0,0) et des coordonnées correctes
func initialize_matrix(rows: int, cols: int, default_value = 0.0):
	matrix = []
	
	# Calcul des limites des coordonnées
	min_x = -rows / 2
	max_x = rows / 2 - 1
	min_y = -cols / 2
	max_y = cols / 2 - 1
	
	for i in range(rows):
		matrix.append([])  # Créer une nouvelle ligne
		for j in range(cols):
			matrix[i].append({
				"x": min_x + i,
				"y": min_y + j,
				"value": default_value
			})

# Augmente la valeur à une certaine coordonnée (x, y)
func increase_value(x: int, y: int, amount: int = 1):
	var xBase64 = round(x/64) 
	var yBase64 = round(y/64)
	
	if is_within_bounds(xBase64, yBase64):
		matrix[xBase64][yBase64]["value"] += amount
	else:
		print("Erreur: Coordonnées hors limites")

# Diminue la valeur de toutes les coordonnées sans descendre en dessous de 0
func decrease_all_values(amount: float):
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			matrix[i][j]["value"] = max(0, matrix[i][j]["value"] - amount)

# Vérifie si les coordonnées (x, y) sont bien dans la matrice
func is_within_bounds(x: int, y: int) -> bool:
	return x >= min_x and x <= max_x and y >= min_y and y <= max_y

# Affiche la matrice avec un affichage structuré et aligné pour les floats
func print_matrix():
	print("\n=== MATRICE ===")
	# Parcours de la matrice du bas vers le haut
	for j in range(min_x, max_y + 1):
		var row_str = ""
		# Parcours de chaque ligne de la matrice
		for i in range(min_x, max_x + 1):
			# Formater les valeurs flottantes avec 2 décimales
			var formatted_value = "%.2f" % matrix[i][j]["value"]
			# Ajouter des espaces pour aligner les valeurs à droite
			while formatted_value.length() < 6:  # Ajuste à 6 caractères (3 chiffres + 2 décimales + espace)
				formatted_value = " " + formatted_value
			# Ajouter la valeur formatée à la ligne
			row_str += formatted_value + " "
		print(row_str)  # Afficher la ligne
	print("================\n")  # Ligne de séparation
