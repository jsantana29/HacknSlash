extends CharacterBody2D
class_name Ghost

var tag = "ghost"
var float_speed = 25
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * float_speed
	move_and_slide()


func _on_detection_radius_body_entered(body):
	player = body # Replace with function body.


func _on_detection_radius_body_exited(body):
	player = null # Replace with function body.
