extends CharacterBody2D
class_name Player

var tag = "player"

var SPEED = 300.0
var DASH_SPEED = 1000.0
var JUMP_VELOCITY = -400.0


var jumped = false
var melee = false
var current_direction = 1
var dashing = false
var dead = false
var attack_buffered = false
var jump_buffered = false
var hitbox_active = false
var dash_duration = 0.10
var chain_duration = 0.75
var death_duration = 3
var jump_timer = 0
var coyote_duration = 0.1

var combo_counter = 0
var max_combo = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_timer = $DashTimer
@onready var melee_timer = $MeleeTimer
@onready var death_timer = $DeathTimer
@onready var hitbox_right = $Hitbox_right/CollisionShape2D
@onready var hitbox_left = $Hitbox_left/CollisionShape2D
@onready var game_manager = %GameManager
@onready var ui_manager = %UI
@onready var health_component = $HealthComponent
@onready var hurtbox = $Hurtbox/CollisionShape2D
@onready var coyote_timer = $CoyoteTimer



var current_hitbox = 0

func _ready():
	current_hitbox = hitbox_right
	hitbox_right.disabled = true
	hitbox_left.disabled = true
	ui_manager.update_health(health_component.health)

func _physics_process(delta):
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if !jumped:
			animated_sprite.play("jump")
			jumped = true
			coyote_timer.start_timer(coyote_duration)
	
	if jump_buffered:
		jump_timer -= delta
	
	if is_on_floor():
		if jump_buffered and jump_timer > 0:
			jump()
			jump_buffered = false
		jumped = false
	
	if Input.is_action_just_pressed("jump") and jumped:
		jump_buffered = true
		jump_timer = 0.1
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer.is_going()) and !dead:
		jump()
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	if !dead:
		if direction > 0:
			animated_sprite.flip_h = false
			current_direction = 1
		elif direction < 0:
			animated_sprite.flip_h = true
			current_direction = -1
		else:
			if is_on_floor() and !melee:
				animated_sprite.play("idle")
	
	
	if Input.is_action_just_pressed("dash") and !dashing and !dead:
		#set_dash_timer()
		dash_timer.start_dash(dash_duration)
		dashing = true
		if melee:
			melee = false
		
	if Input.is_action_just_pressed("melee") and melee:
		attack_buffered = true
	
	if Input.is_action_just_pressed("melee") and !dead:
		melee = true
		
			
	if dashing and !dead:
		hurtbox.disabled = true
		dash(current_direction)
		
	if !melee_timer.is_chainable() and !melee and !dead:
		combo_counter = 0
	
	
	if !death_timer.is_dying() and dead:
		game_manager.reset_level()
		
	
	if melee:
		melee_attack()
		
	
	
	if direction and !dashing and !melee and !dead:
		velocity.x = direction * SPEED
		if is_on_floor():
			animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
	
func dash(direction):
	#velocity.x = move_toward(velocity.x, DASH_SPEED * direction, DASH_SPEED * direction)
	velocity.x = direction * DASH_SPEED
	velocity.y = 0
	
	animated_sprite.play("dash")
	if !dash_timer.is_dashing():
		dashing = false
		hurtbox.disabled = false
		
func melee_attack():
	if combo_counter > max_combo:
		combo_counter = 0
	
	
	if !hitbox_active:
		if current_direction > 0:	
			current_hitbox = hitbox_right
		elif current_direction < 0:
			current_hitbox = hitbox_left
			
		current_hitbox.disabled = false
		hitbox_active = true
		
	if is_on_floor():
		ground_combo()
	else:
		velocity.y = 0
		air_combo()
	
	

func ground_combo():
	match combo_counter:
		0:
			animated_sprite.play("ground_combo_1")
		1:
			animated_sprite.play("ground_combo_2")
		2:
			animated_sprite.play("ground_combo_3")
		_:
			melee = false
			
func air_combo():
	match combo_counter:
		0:
			animated_sprite.play("air_combo_1")
		1:
			animated_sprite.play("air_combo_2")
		2:
			animated_sprite.play("air_combo_3")
		_:
			melee = false
	

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "ground_combo_1":
		melee = false
		combo_counter += 1
		melee_timer.start_chain_timer(chain_duration)
		check_attack_buffer()
	if animated_sprite.animation == "ground_combo_2":
		melee = false
		combo_counter += 1
		melee_timer.start_chain_timer(chain_duration)
		check_attack_buffer()
	if animated_sprite.animation == "ground_combo_3":
		melee = false
		combo_counter += 1
		check_attack_buffer()
	if animated_sprite.animation == "air_combo_1":
		melee = false
		combo_counter += 1
		melee_timer.start_chain_timer(chain_duration)
		check_attack_buffer()
		print(combo_counter)
	if animated_sprite.animation == "air_combo_2":
		melee = false
		combo_counter += 1
		melee_timer.start_chain_timer(chain_duration)
		check_attack_buffer()
		print(combo_counter)
	if animated_sprite.animation == "air_combo_3":
		melee = false
		combo_counter += 1
		check_attack_buffer()
		print(combo_counter)
		#melee_timer.start_chain_timer(chain_duration)
	
	current_hitbox.disabled = true
	hitbox_active = false

func check_attack_buffer():
	if attack_buffered:
		melee = true
		attack_buffered = false
		
func jump():
	velocity.y = JUMP_VELOCITY

func _on_player_dead():
	if !dead:
		dead = true
		animated_sprite.play("die")
		death_timer.start_death(death_duration)

func update_blood():
	ui_manager.update_blood()
	print("Blood updated")


func _on_health_component_health_update(health):
	ui_manager.update_health(health)
