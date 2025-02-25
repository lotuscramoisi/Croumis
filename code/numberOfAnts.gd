extends Control

@onready var label = $NumberOfAnts

func _ready():
	GlobalColony.ants_alive
	
func _process(delta: float) -> void:
	label.text = str(GlobalColony.ants_alive)
