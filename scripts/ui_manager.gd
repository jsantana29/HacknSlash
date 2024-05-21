extends Node

@onready var health_display = $Control_UI/HealthControl/HealthDisplay
@onready var blood_display = $Control_UI/BloodControl/BloodDisplay

var blood_count = 0

@onready var game_manager = %GameManager
# Called when the node enters the scene tree for the first time.
func _ready():
	print("UI initialized")
	blood_display.text = str(blood_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_health(health):
	health_display.text = str(health)
	
func update_blood():
	blood_count += 1
	blood_display.text = str(blood_count)

	
