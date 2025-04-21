extends State
# Action states are: Standing/Walking/Running/Jumping/Falling/Landing/Wall riding/Floating/Dashing

@export
var standing_state: State
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

func enter() -> void:
	super()
	set_collision(1, 18, 0, 0.5, 1.5)

func process_input(event: InputEvent) -> State:
	if get_jump() and parent.jumps_remaining > 0:
		parent.current_acceleration += parent.current_acceleration * 0.5
		return jumping_state
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
	
	# Walk speeds
	parent.current_speed = parent.base_speed * parent.motion_mod
	parent.current_acceleration = parent.base_acceleration * parent.motion_mod * delta
	
	# Speed scaling
	speed_scale = clamp(absf(parent.velocity.x)/100, 0.2, 3)
	animations.speed_scale = speed_scale
	
	# If holding sprint, switch back to sprinting state
	if get_sprint():
		return running_state
	
	# Return standing state when velocity is zero
	if parent.velocity.x == 0 and get_movement_input() == 0:
		return standing_state
	
	# Fall if ever not on the floor
	if !parent.is_on_floor():
		parent.jumps_remaining -= 1
		return falling_state
	return null

func process_frame(delta: float) -> State:
	#If dead, die
	if !parent.is_alive:
		return dead_state
	return null
