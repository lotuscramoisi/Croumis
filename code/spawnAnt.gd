extends Node2D

@export var tilemap: TileMapLayer
@export var ant: PackedScene
@export var spawn_layer: int = 1
@export var enemy_parent: Node2D
 
func _ready() -> void:
	spawn_ant()

# Spawn the ant
func spawn_ant():
	var spawn_positions = get_spawn_positions()
	if spawn_positions.is_empty():
		print("No spawn positions available!")
		return
	
	var spawn_position = spawn_positions.pick_random()
	var enemy = ant.instantiate()

	enemy.position = spawn_position  # Set the position of the ant in the world

	# Optionally, add the ant to an "Enemies" node for organization
	if enemy_parent:
		enemy_parent.add_child(enemy)
	else:
		add_child(enemy)  # If no "Enemies" node, just add it directly to the AntSpawner
	 
# Get positions where ants can spawn
func get_spawn_positions() -> Array:
	var spawn_positions = []
	
	# Get the used cells on the specified layer
	var used_cells = tilemap.get_used_cells()
	
	for cell in used_cells:
		var world_position = tilemap.map_to_local(cell)
		spawn_positions.append(world_position)

	return spawn_positions
