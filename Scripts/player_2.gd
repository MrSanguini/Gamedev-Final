extends CharacterBody2D


@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0,1) var acceleration = 0.1
@export_range(0,1) var decceleration = 0.1

const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	var speed
	if Input.is_action_pressed("sprint"):
		speed = run_speed
	else:
		speed = walk_speed
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, speed * direction, walk_speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * decceleration)

	move_and_slide()
