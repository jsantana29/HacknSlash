extends Node

var blood_drop = preload("res://scenes/blood_drop.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func spawn_blood_on_death(zombie):
	var instance = blood_drop.instantiate()
	instance.position.x = zombie.position.x
	instance.position.y = zombie.position.y
	add_child(instance)
	
func reset_level():
	get_tree().reload_current_scene()
	
func printTest():
	print("It worked")
