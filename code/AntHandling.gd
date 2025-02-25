extends CharacterBody2D

enum State { WANDERING, HUNTING, RETURNING,COLLECTING}

@export var LIFESPAN: float = 1000
@export var SPEED: float = 60

var age: float = 0
var current_state = State.WANDERING
var target_position = Vector2.ZERO
var base_position = Vector2.ZERO
var motivation_to_explore = 0
var global_energy = 0
var is_in_front_of = null
var is_transporting = null


@export var pheromone: PackedScene
@export var pheromone_parent: Node2D
@onready var timer = $Timer
 
func _ready() -> void:
	z_index = 2
	timer.timeout.connect(spawn_phero)
	GlobalColony.add_ants()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_alive(delta)
	
	match current_state:
		State.WANDERING:
			wander_behavior(delta)
		State.HUNTING:
			hunt_behavior()
		State.RETURNING:
			return_behavior()
	
	if current_state != State.COLLECTING: #the ant stop moving when collecting
		move_and_slide()
		
		# Flip the sprite when changing direction
		if velocity.length() > 0:
			rotation = velocity.angle() + PI / 2
			
		if get_slide_collision_count():
			var collision = get_slide_collision(0)
			var collider = collision.get_collider()
			is_in_front_of = collider.name
			if !is_transporting and is_in_front_of == "food":
				current_state = State.COLLECTING
				collect_behavior(collision,collider)
		
func is_alive(delta):
	age += delta
	if age >= LIFESPAN:
		die()
		GlobalColony.remove_ants()

func die():
	queue_free()

func wander_behavior(delta):
	if randf() < 0.05:
		var found_a_trace = pick_direction_using_pheromons()
		
		if !found_a_trace:
			motivation_to_explore += delta
			global_energy += delta
		else:
			motivation_to_explore = 0
		print(motivation_to_explore)
		# If too much time passes without finding any traces, return to base
		if motivation_to_explore > 2.5 || global_energy > 10:
			current_state = State.RETURNING
	
	velocity = velocity.lerp(velocity.normalized() * SPEED, 0.1)

func hunt_behavior():
	var direction_to_target = (target_position - position).normalized()
	
	var noise_offset = Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))
	velocity = (direction_to_target + noise_offset).normalized() * SPEED


func return_behavior():
	var direction_to_base = (base_position - position).normalized()
	
	var noise_offset = Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))
	velocity = (direction_to_base + noise_offset).normalized() * SPEED
	
	# If close to base, reset to wandering
	if position.distance_to(base_position) < 100:
		is_transporting = null
		current_state = State.WANDERING
	
func pick_direction_using_pheromons():
	var current_angle = velocity.angle()
	var best_angle = current_angle
	var max_pheromone = 1
	
	var directions = [
		Vector2(1, 0),    # Right
		Vector2(-1, 0),   # Left
		Vector2(0, 1),    # Bottom
		Vector2(0, -1),   # Top
		Vector2(1, 1),    # Bottom-right
		Vector2(-1, 1),   # Bottom-left
		Vector2(1, -1),   # Top-right
		Vector2(-1, -1)   # Top-left
	]

	# Check all directions and find the one with the highest pheromone value
	for dir in directions:
		var key = GlobalPheromon.get_key(position.x + dir.x, position.y + dir.y)
		var pheromone_value = GlobalPheromon.matrix.get(key, 0) # Default to 0 if not found
		
		if pheromone_value > max_pheromone:
			max_pheromone = pheromone_value
			best_angle = (position + dir).angle_to_point(position)
			print("Best anglue", best_angle)
			
	var angle_change = randf_range(-PI / 5, PI / 5)
	velocity = Vector2(cos(best_angle + angle_change), sin(best_angle + angle_change)) * SPEED
	
	if(max_pheromone>3):
		return true 
	return false


func start_hunting(target: Vector2):
	current_state = State.HUNTING
	target_position = target
	
func collect_behavior(collision, collider):
	print("Collision avec :", collider.name)
	
	await get_tree().create_timer(3.0).timeout
	#if collider.has_method("was_eaten"): 
	collider.was_eaten(collision.get_position())
	is_transporting = is_in_front_of
	is_in_front_of = null
	current_state = State.RETURNING
	
func spawn_phero():
	if is_transporting:
		GlobalPheromon.increase_value(position.x,position.y,10)
	elif current_state == State.RETURNING:
		GlobalPheromon.increase_value(position.x,position.y,-5)
	else:
		GlobalPheromon.increase_value(position.x,position.y,1)
	
	
	if pheromone:
		var new_pheromone = pheromone.instantiate()
		new_pheromone.position = position
		
		if pheromone_parent:
			pheromone_parent.add_child(new_pheromone)
		else:
			get_parent().add_child(new_pheromone)
	else:
		print("No enemy scene assigned!")
