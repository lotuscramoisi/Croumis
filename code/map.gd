extends TileMapLayer

var map_lens : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in map_lens:
		for j in map_lens:
			set_cell(Vector2i(i-map_lens/2,j-map_lens/2),2 ,Vector2i(3,2))
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
