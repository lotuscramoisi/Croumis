extends TileMapLayer

var dico_phero: Dictionary = {} 
var max_value = 10

var timer = 0.0

func _ready() -> void:
	var tile_set_preload = preload("res://scene/pheromones.tres")  # Charge un TileSet
	tile_set = tile_set_preload
	scale.x = 0.5
	scale.y = 0.5
	
func _process(delta: float) -> void:
	# Timer pour exécuter l'action toutes les 3 secondes
	timer += delta
	if timer >= 3.0:
		timer = 0.0
		decrease_all_values(0.1)  # Diminuer la valeur de toutes les coordonnées


	
func get_key(position : Vector2) -> Vector2i:
	return Vector2i(round(position.x / 16), round(position.y / 16))

# Augmente la valeur à une certaine coordonnée (x, y)
func increase_value(position : Vector2, type : String, amount: int = 1):
	var key = get_key(position)
	if key in dico_phero and dico_phero[key].has(type):
		dico_phero[key][type] = min(dico_phero[key][type] + amount, max_value)
	else:
		if key not in dico_phero:
			set_cell(key,0 ,Vector2i(3,3))
			dico_phero[key] = {}
		dico_phero[key][type] = min(amount, max_value)

# Diminue la valeur de toutes les coordonnées sans descendre en dessous de 0
func decrease_all_values(amount: float):
	var pheros_to_remove = []
	
	for key in dico_phero.keys():
		for type in dico_phero[key].keys():
			dico_phero[key][type] = max(0, dico_phero[key][type] - amount) # Between 0 and previous value - amount
			if dico_phero[key][type] == 0:
				pheros_to_remove.append({"key" : key,"type" : type})  # Store keys to delete after iteration

	# Remove empty values to keep dictionary small
	for phero in pheros_to_remove:
		dico_phero[phero["key"]].erase(phero["type"])
		if dico_phero[phero["key"]].keys().is_empty():
			dico_phero.erase(phero["key"])
			erase_cell(phero["key"])
			


# Print only existing values (sparse dico_phero)
func print_dico_phero():
	print("\n=== dico_phero ===")
	for key in dico_phero.keys():
		for type in dico_phero[key].keys():
			print(str(key) + "/" + type + " -> " + str(dico_phero[key][type]))
	print("================\n")
