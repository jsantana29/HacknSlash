extends Node2D

var randomX
var randomY

var duration = 0.1

@onready var blood_timer = $BloodTimer
@onready var ui_manager = %UI

signal blood_pickup

func _on_area_2d_body_entered(body):
	print("Passed through blood")
	body.update_blood()
	#blood_pickup.emit()
	queue_free()
