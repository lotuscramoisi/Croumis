extends Node

var ants_alive = 0

func add_ants():
	ants_alive += 1
	
func remove_ants():
	ants_alive -= 1
	
func set_ants_alive(count):
	ants_alive = count
