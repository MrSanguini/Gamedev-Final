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
var floating_state: State
@export
var dashing_state: State
@export
var dead_state: State
@export
var hurt_state: State

@export
var landing_time : float = 0.1
var landing_timer :float = 0.0

func enter() -> void:
	super()
	set_collision(0, 22, 0, 0.5, 1)
	animations.position.x = 2
	animations.position.y = 21
	animations.rotation_degrees = 0
	animations.scale.x = 1
	animations.scale.y = 1
	parent.jumps_remaining = parent.max_jumps
	landing_timer = landing_time

func process_input(event: InputEvent) -> State:
	super(event)
	if get_jump() and parent.jumps_remaining > 0:
		return jumping_state
	if get_dash() and parent.can_dash:
		return dashing_state
	if get_sprint():
		return running_state
	return null
	
func process_physics(delta: float) -> State:
	super(delta)
	# Reset dash
	if parent.dash_cooldown >= parent.max_dash_cooldown:
		parent.can_dash = true
		
	# Time to be spent in landing state
	landing_timer -= delta

	if landing_timer <= 0.0:
		return walking_state
	
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
