extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# Base stats
@export var top_speed: float = 150.0
@export var max_accel: float = 450
@export var accel_mod: float = 1.0 
@export var speed_mod: float = 1.0

@export var sprint_accel_mod: float = 1.8
@export var sprint_speed_mod: float = 1.8

# Stats that are modified on each process
var speed = top_speed * speed_mod
var accel = max_accel * accel_mod

# Other stats
@export var jump_velocity: float = -350.0
var turn: int = 1
@export var max_jumps: int = 2
var jumps: int = 1

# Speed scales
var speed_scale_walk: float
var speed_scale_run: float
var speed_scale_default = 1

# State Dictionary
var states = {"IDLE":1, "MOVING":0, "JUMPING":0, "WALKING":0, "FALLING":0, "RUNNING":0, "STOPPING":0}

func handle_movement(delta: float) -> void:
	#if true:
		#print(states) # Debugging
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	# Modified stats
	speed = top_speed * speed_mod
	accel = max_accel * accel_mod * delta
	
	# Speed scales
	speed_scale_walk = clamp(speed/100, 0.2, 3) 
	speed_scale_run = speed/180
	
	# Turning of player sprite based on last direction input
	if direction < 0:
		turn = -1
	elif direction > 0:
		turn = 1
	player_sprite.flip_h = turn < 0
	
	# Movement of player sprite
	if direction:
		moving_state()
		if Input.is_action_pressed("sprint") and is_on_floor():
			running_state()
		elif is_on_floor():
			walking_state()
		elif (not is_on_floor()) and velocity.y >= 0:
			falling_state()
		else:
			player_sprite.speed_scale = speed_scale_default
			player_sprite.play("jump ascend")
			alter_collision(3, -2, 0, 1.11, 1.12)
	else:
		if velocity.x == 0:
			if is_on_floor():
				idle_state()
			else:
				if velocity.y >= 0:
					falling_state()
				else:
					player_sprite.speed_scale = speed_scale_default
					player_sprite.play("jump ascend")
					alter_collision(3, -2, 0, 1.11, 1.12)
		else:
			if (not is_on_floor()) and velocity.y >= 0:
				falling_state()
			elif is_on_floor():
				stopping_state()
			else:
				player_sprite.speed_scale = speed_scale_default
				player_sprite.play("jump ascend")
				alter_collision(3, -2, 0, 1.11, 1.12)
	# Handle jump.
	if Input.is_action_pressed("jump"):
		jump_state(velocity.x)
				
	move_and_slide()
	# Debugging
	# print("turn: ", turn)
	# print("velocity: ", velocity.x) 



func moving_state() -> void:
	if states["RUNNING"]:
		accel_mod = sprint_accel_mod
		speed_mod = sprint_speed_mod
	states["MOVING"] = 1
	states["IDLE"] = 0
	states["STOPPING"] = 0
	# If player is trying to turn around
	if ((turn > 0 and velocity.x < 0) or (turn < 0 and velocity.x > 0)) and not states["JUMPING"] and not states["FALLING"]:
		player_sprite.play('turn')
		alter_collision(5, 1.5, 0, 1.15, 0.9)
		accel_mod = 5
	# Aerial version of the previous turn-around code
	elif ((turn > 0 and velocity.x < 0) or (turn < 0 and velocity.x > 0)) and states["JUMPING"]:
		accel_mod = 2.5
	# Cause a slow decceleration if player is moving faster than their current top speed
	elif absf(velocity.x) > speed:
		accel_mod = 0.5
	elif not states["JUMPING"] and not states["FALLING"] and not states["RUNNING"]:
		accel_mod = 1
		speed_mod = 1
	# Accelerate
	velocity.x = move_toward(velocity.x, speed * turn, accel)

	
func jump_state(jump_speed) -> void:
	if jumps > 0:
		velocity.y = move_toward(velocity.y, jump_velocity, 10000 * accel)
		accel_mod = move_toward(accel_mod, 0.5, accel/(2*jump_velocity))
		speed_mod += 0.5
		jumps -= 1
		states["FALLING"] = 0
		player_sprite.speed_scale = speed_scale_default
		player_sprite.play("jump ascend")
		alter_collision(3, -2, 0, 1.11, 1.12)
	if (not states["JUMPING"]) and (not states["FALLING"]):
		velocity.x = jump_speed
		states["JUMPING"] = 1
		states["FALLING"] = 0
		states["IDLE"] = 0
		states["WALKING"] = 0
		states["RUNNING"] = 0
		
func walking_state() -> void:
	if (not states["JUMPING"]):
		jumps = max_jumps
		states["WALKING"] = 1
		states["JUMPING"] = 0
		states["FALLING"] = 0
		states["RUNNING"] = 0
		if is_on_floor() and not ((turn > 0 and velocity.x < 0) or (turn < 0 and velocity.x > 0)):
			player_sprite.speed_scale = speed_scale_walk
			player_sprite.play("walk")
			alter_collision(6, 0.5, 0, 1.5, 0.97)
	
func stopping_state() -> void:
	if (not states["IDLE"]) and (not states["JUMPING"]):
		states["STOPPING"] = 1
		states["WALKING"] = 0
		states["RUNNING"] = 0
		states["MOVING"] = 0
		states["FALLING"] = 0
		accel_mod = 2.5
		velocity.x = move_toward(velocity.x, 0, accel)
		if is_on_floor():
			player_sprite.speed_scale = speed_scale_walk
			player_sprite.play("walk")
			alter_collision(6, 0.5, 0, 1.5, 0.97)
			
func falling_state() -> void:
	if (not is_on_floor()):
		states["FALLING"] = 1
		states["JUMPING"] = 0
		states["IDLE"] = 0
		states["WALKING"] = 0
		states["RUNNING"] = 0
		accel_mod = move_toward(0.5, 1, accel/(2*jump_velocity))
		jumps -= 1
		if velocity.y == 0:
			player_sprite.play("jump neutral")
			alter_collision(5, -2, 0, 1.11, 1.15)
		elif velocity.y > 0:
			player_sprite.speed_scale = speed_scale_default
			player_sprite.play("jump descend")
			alter_collision(2, -2.5, 0, 1.11, 1.1)
	
func idle_state() -> void:
		jumps = max_jumps
		states["IDLE"] = 1
		states["STOPPING"] = 0
		states["MOVING"] = 0
		states["WALKING"] = 0
		states["JUMPING"] = 0
		states["FALLING"] = 0
		states["RUNNING"] = 0
		player_sprite.speed_scale = speed_scale_default
		player_sprite.play("idle")
		alter_collision(2, 0, 0, 1.15, 1)
		
func running_state() -> void:
	if (not states["JUMPING"]):
		jumps = max_jumps
		states["IDLE"] = 0
		states["STOPPING"] = 0
		states["WALKING"] = 0
		states["JUMPING"] = 0
		states["FALLING"] = 0
		states["RUNNING"] = 1
		if is_on_floor() and not ((turn > 0 and velocity.x < 0) or (turn < 0 and velocity.x > 0)):
			player_sprite.speed_scale = speed_scale_run
			player_sprite.play("run")
			alter_collision(9, 1.8, 0, 2, 0.9)

func alter_collision(position_x, position_y, body_rotation, scale_x, scale_y):
	collision.position.x = position_x
	collision.position.y = position_y
	collision.rotation_degrees = body_rotation
	collision.scale.x = scale_x
	collision.scale.y = scale_y

func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity += 1.3 * (get_gravity() * delta)
		
	handle_movement(delta)
