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
var standing_state: State
@export
var dashing_state: State
@export
var landing_state: State
@export
var wall_sticking_state: State
@export
var dead_state: State
@export
var wall_stick_time: float = 0.2
var wall_stick_timer: float = wall_stick_time

func enter() -> void:
	super()
	set_collision(1, 18, 0, 0.5, 1.5)

func process_input(event: InputEvent) -> State:
	if get_jump() and parent.jumps_remaining > 0:
		return jumping_state
		
	if get_dash() and parent.can_dash:
		return dashing_state
	return null
	
func process_physics(delta: float) -> State:
	super(delta)
	# Landing state if they touch the ground
	if parent.is_on_floor():
		return landing_state
		
	# Fall if downward velocity goes up
	if parent.velocity.y > 0:
		return falling_state
	
	# Stick to walls if jump is held whilst moving into them
	if parent.is_on_wall_only() and (parent.turn == get_movement_input()):
		if get_jump_hold():
			wall_stick_timer -= delta
			if wall_stick_timer <= 0:
				return wall_sticking_state
		else:
			wall_stick_timer = wall_stick_time
	return null

func exit() -> void:
	pass
	
func process_frame(delta: float) -> State:
	#If dead, die
	if !parent.is_alive:
		return dead_state
	return null
