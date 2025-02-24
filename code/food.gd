extends TileMapLayer

var map_lens : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 200:
		set_cell(Vector2i(randi_range(0,100) -map_lens/2,randi_range(0,100)-map_lens/2),0 ,Vector2i(randi_range(0,2),0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
