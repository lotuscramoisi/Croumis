extends TileMapLayer

var map_lens : int = 500
var dico_of_food = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 1200:
		set_cell(Vector2i(randi_range(0,map_lens) -map_lens/2,randi_range(0,map_lens)-map_lens/2),0 ,Vector2i(randi_range(0,2),0))
	
	for food_position in get_used_cells():
		dico_of_food[food_position] = 100
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func was_eaten(food_position: Vector2i):
	var food_map_position: Vector2i = local_to_map(food_position)
	
	# Liste des positions à tester (d'abord la position principale, puis les voisines)
	var positions_to_check = [
		food_map_position,
		food_map_position + Vector2i(1, 0),  # Droite
		food_map_position + Vector2i(0, 1),  # Bas
		food_map_position + Vector2i(-1, 0), # Gauche
		food_map_position + Vector2i(0, -1)  # Haut
		]
	
	# Vérifie quelle position est présente dans le dictionnaire
	for pos in positions_to_check:
		if pos in dico_of_food:
			dico_of_food[pos] -= 10  # Diminue la quantité de nourriture
			if dico_of_food[pos] <= 0:
				erase_cell(pos)  # Supprime la cellule si elle est complètement manger
			break  # Une seule position doit être affectée, donc on sort de la boucle

	
