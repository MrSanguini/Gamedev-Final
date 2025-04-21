extends State

@export
var wall_jumping_state: State
@export
var wall_sliding_state: State
@export
var wall_sticking_state: State
@export
var falling_state: State

@export
var gravity_increase: float = 0.5

func enter() -> void:
	super()
	gravity_increase = parent.gravity * gravity_increase
	animations.position.x = -5
	animations.position.y = 10
	animations.rotation_degrees = -90
	animations.scale.x = 1
	animations.scale.y = 1
	set_collision(15, 3, -90, 2, 0.96)
	parent.velocity.x = 0
	parent.gravity += gravity_increase
	
func process_input(event: InputEvent) -> State:
	if get_jump():
		return wall_jumping_state
	if Input.is_action_just_pressed('down'):
		return falling_state
	return null
	
func process_physics(delta: float) -> State:
	print("\nCurrent State: ", get_state_name())
	print("\nCurrent acceleration: ", parent.current_acceleration)
	print("\nCurrent deceleration: ", parent.current_deceleration)
	print("\nCurrent horizontal velocity: ", parent.velocity.x)
	print("\nCurrent vertical velocity: ", parent.velocity.y)
	animations.flip_h = false
	parent.velocity.x = 0
	if parent.velocity.y == 0:
		return wall_sticking_state
	if parent.velocity.y < 0:
		return wall_sliding_state
	if !parent.is_on_wall_only():
		return falling_state
	return null
	
func exit() -> void:
	parent.gravity -= gravity_increase
