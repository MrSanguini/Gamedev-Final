extends State
# Action states are: Standing/Walking/Running/Jumping/Falling/Landing/Wall riding/Floating/Dashing

@export
var walking_state: State
var running_state: State
var jumping_state: State
var falling_state: State
var landing_state: State
var wall_riding_state: State
var floating_state: State
var dashing_state: State

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	if get_jump() and parent.is_on_floor():
		return jumping_state
	if get_movement_input() != 0.0:
		return walking_state
	if get_dash():
		return dashing_state
	if get_sprint():
		return running_state
	return null
	
func process_physics(delta: float) -> State:
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return falling_state
	return null
