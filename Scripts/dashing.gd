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
var standing_state: State
@export
var landing_state: State
@export
var wall_sticking_state: State
@export
var dead_state: State

@export
var dash_time : float = 0.4
@export
var power: float = 1000

var dash_timer : float = 0.0
var direction: int

func enter() -> void:
	parent.can_dash = false
	direction = parent.turn
	super()
	set_collision(1, 18, 0, 0.5, 1.5)
	parent.velocity.x = power * direction
	parent.velocity.y = 0
	parent.gravity_mod = 0.3
	dash_timer = dash_time
	hitbox_component.iframe = true
	parent.dash_cooldown = parent.max_dash_cooldown
	
func process_input(event: InputEvent) -> State:
	return null
	
func process_physics(delta: float) -> State:
	animations.flip_h = direction < 0
	dash_timer -= delta
	parent.velocity.x = power * direction
	if dash_timer <= 0.0:
		return landing_state
	# Stick to walls
	if parent.is_on_wall_only():
		return wall_sticking_state
	return null

func exit() -> void:
	parent.gravity_mod = 1
	hitbox_component.iframe = false
	if parent.is_on_floor():
		parent.velocity.x -= parent.velocity.x * 0.5
		parent.jumps_remaining = parent.max_jumps
	
func process_frame(delta: float) -> State:
	#If dead, die
	if !parent.is_alive:
		return dead_state
	return null
