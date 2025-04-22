extends State
# Action states are: Standing/Walking/Running/Jumping/Falling/Landing/Wall riding/Floating/Dashing

@export
var walking_state: State
@export
var standing_state: State
@export
var jumping_state: State
@export
var falling_state: State
@export
var floating_state: State
@export
var dashing_state: State
@export
var running_state: State
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
	if get_dash() and parent.can_dash:
		return dashing_state
	if !get_sprint():
		return walking_state
	return null
	
func process_physics(delta: float) -> State:
	super(delta)
	# Reset dash
	if parent.dash_cooldown <= 0:
		parent.can_dash = true
		
	# Run speeds
	parent.current_speed = parent.base_speed * parent.motion_mod * parent.sprint_mod
	parent.current_acceleration = parent.base_acceleration * parent.motion_mod * delta * parent.sprint_mod
	
	# Return standing state when velocity is zero
	if parent.velocity.x == 0 and get_movement_input() == 0:
		return standing_state
	
	# Return to running
	if parent.turn == parent.velocity.x/absf(parent.velocity.x):
		return running_state
	
	# Speed scaling
	speed_scale = absf(parent.velocity.x)/180
	animations.speed_scale = speed_scale
	
	# Fall if ever not on the floor
	if !parent.is_on_floor():
		parent.jumps_remaining -= 1
		return falling_state
	
	if parent.just_hit:
		return hurt_state
	return null

func process_frame(delta: float) -> State:
	#If dead, die
	if !parent.is_alive:
		return dead_state
	return null
