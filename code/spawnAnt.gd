extends Node2D

@export var tilemap: TileMapLayer          # Reference to your TileMap
@export var ant: PackedScene         # The PackedScene for the ant enemy
@export var spawn_layer: int = 1      # The spawn layer in your TileMap (if you are using layers)
@export var enemy_parent: Node2D     # Optional: Parent node for organization (optional)
 
func _ready() -> void:
	pass

# Spawn the ant
func spawn_ant():
	var spawn_positions = get_spawn_positions()
	if spawn_positions.is_empty():
		print("No spawn positions available!")
		return
	
	var spawn_position = spawn_positions.pick_random()
	var enemy = ant.instantiate()  # Create a new instance of the ant

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
