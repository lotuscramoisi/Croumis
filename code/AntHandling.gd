extends CharacterBody2D

enum State { WANDERING, HUNTING, RETURNING,COLLECTING}

@export var LIFESPAN: float = 1000
@export var SPEED: float = 40

const FIELDS_OF_VISION = [
		Vector2(1, 0) ,    # Right
		Vector2(-1, 0) ,   # Left
		Vector2(0, 1) ,    # Bottom
		Vector2(0, -1) ,   # Top
		Vector2(0, 0) ,    # center
		Vector2(1, 1) ,    # Bottom-right
		Vector2(-1, 1) ,   # Bottom-left
		Vector2(1, -1) ,   # Top-right
		Vector2(-1, -1)    # Top-left
	]

var age: float = 0
var current_state = State.WANDERING
var target_position = Vector2.ZERO
var base_position = Vector2.ZERO
var motivation_to_explore = 0
var motivation_to_refind_a_trace = 0
var global_energy = 0
var is_in_front_of = null
var is_transporting = null
var precision = 0.05
var trace_had_been_found

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
	if randf() < precision:
		var found_a_trace = pick_direction_using_pheromons(delta)
		if !found_a_trace:
			motivation_to_explore += delta
			global_energy += delta
		else:
			motivation_to_explore = 0
			global_energy += delta/16
		#print(motivation_to_explore)
		# If too much time passes without finding any traces, return to base
		if motivation_to_explore > 5 || global_energy > 20:
			current_state = State.RETURNING
	
	velocity = velocity.lerp(velocity.normalized() * SPEED, 0.1)

func hunt_behavior():
	var direction_to_target = (target_position - position).normalized()
	
	var noise_offset = Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))
	velocity = (direction_to_target + noise_offset).normalized() * SPEED


func return_behavior():
	var direction_to_base = (base_position - position).normalized()
	
	precision = 0.05
	
	if randf() < 0.15:
		var noise_offset = Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))
		velocity = (direction_to_base + noise_offset).normalized() * SPEED
	
	# If close to base, reset to wandering
	if position.distance_to(base_position) < 100:
		if is_transporting != null:
			GlobalColony.add_food_in_colony()

		is_transporting = null
		motivation_to_explore = 0
		global_energy = 0
		current_state = State.WANDERING
	
func pick_direction_using_pheromons(delta):
	var current_angle = velocity.angle()
	var best_angle = {}
	var max_pheromone = {}
	var angle_change


	var direction_vector = get_direction_vector(current_angle)
	
	var fields_of_vision_according_to_direction = []
	for pos in FIELDS_OF_VISION:
		fields_of_vision_according_to_direction.append(pos + direction_vector)
		
	# Check all view and find the one with the highest pheromone value
	for view in fields_of_vision_according_to_direction:
		var key = GlobalPheromon.get_key(position)
		var pheromone_value = GlobalPheromon.dico_phero.get(key + Vector2i(view)) # Default to 0 if not found
		
		if pheromone_value:
			for type in pheromone_value.keys():
				if !max_pheromone.has(type) or pheromone_value[type] > max_pheromone[type]:
					max_pheromone[type] = pheromone_value[type]
					if type == "food":
						best_angle[type] = position.angle_to_point(position + view*16)
					else:
						best_angle[type] = (position + view).angle_to_point(position)
		
	if max_pheromone.has("food") and abs(best_angle["food"] - (base_position - position).normalized().angle()) > deg_to_rad(45):
		velocity = Vector2(cos(best_angle["food"]), sin(best_angle["food"])) * SPEED
		precision = 0.6
		trace_had_been_found = true
		return true
	elif trace_had_been_found:
		angle_change = randf_range(0, PI / 3)
		velocity = Vector2(cos(current_angle + angle_change), sin(current_angle + angle_change)) * SPEED
		precision = 0.1
		motivation_to_refind_a_trace =+ delta
		if motivation_to_explore > 1:
			trace_had_been_found = false
			motivation_to_refind_a_trace = 0
		return false
	else:
		angle_change = randf_range(-PI / 5, PI / 5)
		velocity = Vector2(cos(current_angle + angle_change), sin(current_angle + angle_change)) * SPEED
		precision = 0.05
		return false
	
	
func get_direction_vector(current_angle):
	var threshold = 0.5  # Seuil pour forcer la direction dominante
	var x = cos(current_angle)
	var y = sin(current_angle)
	
	var rounded_x = 1 if x > threshold else -1 if x < -threshold else 0
	var rounded_y = 1 if y > threshold else -1 if y < -threshold else 0
	
	return Vector2(rounded_x, rounded_y) * 2


func start_hunting(target: Vector2):
	current_state = State.HUNTING
	target_position = target
	
func collect_behavior(collision, collider):
	print("Collision avec :", collider.name)
	
	await get_tree().create_timer(3.0).timeout
	#if collider.has_method("was_eaten"): 
	collider.was_eaten(collision.get_collider_rid())
	is_transporting = is_in_front_of
	is_in_front_of = null
	current_state = State.RETURNING
	
func spawn_phero():
	if is_transporting:
		GlobalPheromon.increase_value(position,"food",5)
	elif current_state == State.RETURNING:
		GlobalPheromon.increase_value(position,"returning",1)
	else:
		GlobalPheromon.increase_value(position,"wandering",1)
