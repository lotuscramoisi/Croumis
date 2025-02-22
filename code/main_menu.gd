class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var game = preload("res://scene/game.tscn") as PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.button_down.connect(start_button_pressed)
	exit_button.button_down.connect(exit_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game)
	
func exit_button_pressed() -> void:
	get_tree().quit()
