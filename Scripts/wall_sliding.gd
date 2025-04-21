extends State

@export
var wall_jumping_state: State
@export
var wall_running_state: State
@export
var wall_sticking_state: State
@export
var falling_state: State

@export
var gravity_reduction: float = 0.7

func enter() -> void:
	super()
	gravity_reduction = parent.gravity * gravity_reduction
	set_collision(6, 5, 0, 1.5, 1)
	parent.velocity.x = 0
	parent.gravity -= gravity_reduction
	
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
	animations.flip_h = parent.up_direction.x < 0
	animations.flip_h = parent.turn > 0
	parent.velocity.x = 0
	if parent.velocity.y == 0:
		return wall_sticking_state
	if parent.velocity.y < 0:
		return wall_running_state
	if !parent.is_on_wall_only():
		return falling_state
	return null
	
func exit() -> void:
	parent.gravity += gravity_reduction
	
