extends TileMapLayer

var map_lens : int = 500
var dico_of_food = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 100:
		set_cell(Vector2i(randi_range(0,map_lens) -map_lens/2,randi_range(0,map_lens)-map_lens/2),0 ,Vector2i(randi_range(0,2),0))
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func was_eaten(food_body: RID):

	if !dico_of_food.has(food_body):
		dico_of_food[food_body] = 100
		
	dico_of_food[food_body] -= 10  # Diminue la quantité de nourriture
	if dico_of_food[food_body] <= 0:
		dico_of_food.erase(food_body)
		erase_cell(get_coords_for_body_rid(food_body))  # Supprime la cellule si elle est complètement manger

	
