extends State
# Action states are: Standing/Walking/Running/Jumping/Falling/Landing/Wall riding/Floating/Dashing

@export
var walking_state: State
@export
var running_state: State
@export
var jumping_state: State
@export
var falling_state: State
@export
var floating_state: State
@export
var dashing_state: State
@export
var dead_state: State
@export
var hurt_state: State

func enter() -> void:
	super()
	set_collision(1, 18, 0, 0.5, 1.5)

func process_input(event: InputEvent) -> State:
	super(event)
	if get_jump() and parent.jumps_remaining > 0:
		return jumping_state
	if get_movement_input() != 0.0:
		return walking_state
	if get_dash() and parent.can_dash:
		return dashing_state
	if get_sprint():
		return running_state
	return null
	
func process_physics(delta: float) -> State:
	super(delta)
	# Reset dash
	if parent.dash_cooldown <= 0:
		parent.can_dash = true
		
	# Fall if ever not on the floor
	if !parent.is_on_floor():
		parent.jumps_remaining -= 1
		return falling_state
	#If moving
	if absf(parent.velocity.x) > 0:
		return walking_state
		
	if parent.just_hit:
		return hurt_state
	return null
	
func process_frame(delta: float) -> State:
	#If dead, die
	if !parent.is_alive:
		return dead_state
	return null
