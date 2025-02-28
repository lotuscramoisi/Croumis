extends Control

@onready var label = $NumberOfAnts
@onready var foodLabel = $FoodInColony

func _ready():
	GlobalColony.ants_alive
	GlobalColony.food_in_colony
		
func _process(delta: float) -> void:
	label.text = str(GlobalColony.ants_alive)
	foodLabel.text = str(GlobalColony.food_in_colony)
