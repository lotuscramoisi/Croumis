extends Node2D

@export var tilemap: TileMapLayer
@export var ant: PackedScene
@export var spawn_layer: int = 2
@export var base_ants: int = 20
@export var enemy_parent: Node2D
@onready var timer = $Timer
 
func _ready() -> void:
	#timer.timeout.connect(spawn_ant)
	for i in base_ants:
		spawn_ant()
		
func _process(delta: float) -> void:
	# Spawn ants when more food than 5
	var food_in_colony = GlobalColony.food_in_colony
	if food_in_colony >= 5:
		GlobalColony.food_in_colony -= food_in_colony
		spawn_ant()

func spawn_ant():
	#print("Spawn ant")
	var spawn_positions = get_spawn_positions()
	if spawn_positions.is_empty():
		print("No spawn positions available!")
		return
	
	var spawn_position = spawn_positions.pick_random()
	var enemy = ant.instantiate()

	enemy.position = spawn_position

	if enemy_parent:
		enemy_parent.add_child(enemy)
	else:
		add_child(enemy)

func get_spawn_positions() -> Array:
	var spawn_positions = []
	
	var used_cells = tilemap.get_used_cells()
	
	for cell in used_cells:
		var world_position = tilemap.map_to_local(cell)
		spawn_positions.append(world_position)

	return spawn_positions
