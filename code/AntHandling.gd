extends Node2D

enum State { WANDERING, HUNTING}


@export var LIFESPAN: float = 100
@export var SPEED: float = 60
var age: float = 0
var velocity = Vector2.ZERO
var current_state = State.WANDERING
var target_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pick_random_direction()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	is_alive(delta)
	
	match current_state:
		State.WANDERING:
			wander_behavior()
		State.HUNTING:
			hunt_behavior()
	
	position += delta * velocity
	
	# Flip the sprite when changing direction
	if velocity.length() > 0:
		rotation = velocity.angle() + PI / 2

func is_alive(delta):
	age += delta
	if age >= LIFESPAN:
		die()

func die():
	queue_free()

func wander_behavior():
	if randf() < 0.10:
		pick_not_so_random_direction()
	
	velocity = velocity.lerp(velocity.normalized() * SPEED, 0.1)

func hunt_behavior():
	var direction_to_target = (target_position - position).normalized()
	
	var noise_offset = Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))
	velocity = (direction_to_target + noise_offset).normalized() * SPEED

func pick_random_direction():
	var angle = randf_range(0, TAU)
	velocity = Vector2(cos(angle), sin(angle))
	

func pick_not_so_random_direction():
	var current_angle = velocity.angle()
	var angle_change = randf_range(-PI / 10, PI / 10)
	
	var new_angle = current_angle + angle_change  # Adjust angle smoothly
	velocity = Vector2(cos(new_angle), sin(new_angle)) * SPEED  # Apply new direction

func start_hunting(target: Vector2):
	current_state = State.HUNTING
	target_position = target
