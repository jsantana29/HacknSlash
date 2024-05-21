extends CharacterBody2D

var health = 5
var damage_self = 0
var duration = 2
var hitstun_duration = 1
var target
var tag = "zombie"

@onready var damage_label = $DamageLabel
@onready var damage_timer = $DamageTimer
@onready var blood_particles = $GPUParticles2D

@onready var game_manager = %GameManager

@onready var ray_cast_2d_right = $RayCast2DRight
@onready var ray_cast_2d_left = $RayCast2DLeft
@onready var collision_shape_2d = $Area2D/CollisionShape2D

@onready var hitstun = $Hitstun

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var blood_drop = preload("res://scenes/blood_drop.tscn")

signal zombie_death

# Called when the node enters the scene tree for the first time.
func _ready():
	damage_label.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if damage_timer.is_stopped():
		damage_label.visible = false
		damage_self = 0
		
	if ray_cast_2d_left.is_colliding() and !hitstun.is_hitstun():
		target = ray_cast_2d_left.get_collider()
		position.x = move_toward(position.x, target.position.x, 1)
	if ray_cast_2d_right.is_colliding() and !hitstun.is_hitstun():
		target = ray_cast_2d_right.get_collider()
		position.x = move_toward(position.x, target.position.x, 1)
		
	move_and_slide()
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("Zombie ran through!")
	
	
func damage_zombie():
	health -= 1
	damage_self += 1
	hitstun.start_hitstun(hitstun_duration)
	
	
	if health <= 0:
		game_manager.spawn_blood_on_death(self)
		queue_free()
	


func _on_area_2d_area_entered(area):
	if area.is_in_group("player_hitbox"):
		print("Zombie hit!")
		damage_zombie()
		damage_timer.start_damage_timer(duration)
		damage_label.visible = true
		damage_label.text = str(damage_self)
		blood_particles.emitting = true
	
#ufnc zombie_death():
#	var instance = blood_drop.instantiate()
#	add_child(instance)
#	#queue_free()
