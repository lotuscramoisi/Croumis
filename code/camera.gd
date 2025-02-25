extends CharacterBody2D


const SPEED = 600.0

var zoom_minimum  = Vector2(.500001, .500001)
var zoom_maximum  = Vector2(4.5000001, 4.5000001)
var zoom_speed = Vector2(.1500001, .1500001)

@onready var camera = $Camera2D

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("input_left","input_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("input_up","input_down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("input_scroll_down"):
		if camera.zoom < zoom_maximum:
					camera.zoom += zoom_speed
					pass
	elif Input.is_action_just_pressed("input_scroll_up"):
		if camera.zoom > zoom_minimum:
					camera.zoom -= zoom_speed
					pass
