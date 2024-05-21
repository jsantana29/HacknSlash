extends Node2D

signal dead
signal health_update(health)

var health: int:
	get:
		return health

@onready var ui_manager = %UI

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100
	print("Health Component initialized")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func damage(damage):
	health -= damage
	health_update.emit(health)
	#ui_manager.update_health(health)
	
	if health <= 0:
		health = 0
		print("Dead!")
		dead.emit()
		

func _on_hurtbox_area_entered(area):
	if area.is_in_group("ghost"):
		damage(20)
	if area.is_in_group("zombie"):
		damage(10)
	if area.is_in_group("world_boundary"):
		damage(200)
		
