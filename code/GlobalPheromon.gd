extends Node2D

var matrix: Dictionary = {} 
var min_x: int
var min_y: int
var max_x: int
var max_y: int

var timer = 0.0

func _ready() -> void:
	pass
func _process(delta: float) -> void:
	# Timer pour exécuter l'action toutes les 3 secondes
	timer += delta
	if timer >= 3.0:
		timer = 0.0
		#print_matrix()  # Afficher la matrice
		decrease_all_values(0.1)  # Diminuer la valeur de toutes les coordonnées
		#print_matrix()  # Afficher la matrice après diminution

	
func get_key(x: int, y: int) -> String:
	return str(x) + "," + str(y)

# Augmente la valeur à une certaine coordonnée (x, y)
func increase_value(x: int, y: int, amount: int = 1):
	var xBase64 = round(x/64) 
	var yBase64 = round(y/64)
	

	var key = get_key(xBase64, yBase64)
	if key in matrix:
		matrix[key] += amount
	else:
		matrix[key] = amount

# Diminue la valeur de toutes les coordonnées sans descendre en dessous de 0
func decrease_all_values(amount: float):
	var keys_to_remove = []
	
	for key in matrix.keys():
		matrix[key] = max(0, matrix[key] - amount)
		if matrix[key] == 0:
			keys_to_remove.append(key)  # Store keys to delete after iteration

	# Remove empty values to keep dictionary small
	for key in keys_to_remove:
		matrix.erase(key)

# Check if the coordinates (x, y) are within the allowed range
func is_within_bounds(x: int, y: int) -> bool:
	return x >= min_x and x <= max_x and y >= min_y and y <= max_y

# Print only existing values (sparse matrix)
func print_matrix():
	print("\n=== MATRIX ===")
	for key in matrix.keys():
		print(key + " -> " + str(matrix[key]))
	print("================\n")
