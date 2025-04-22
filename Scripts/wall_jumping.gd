extends State

@export
var dashing_state: State
@export
var wall_sticking_state: State
@export
var falling_state: State
@export
var dead_state: State
@export
var hurt_state: State

@export
var jump_force_mod: float = 0.7

func enter() -> void:
	super()
	set_collision(1, 18, 0, 0.5, 1.5)
	parent.turn *= -1
	parent.jumps_remaining -= 1
	parent.velocity.y = parent.jump_velocity * jump_force_mod
	parent.velocity.x = parent.base_speed * 2.5 * parent.turn

func process_input(event: InputEvent) -> State:
	if get_dash() and parent.can_dash:
		return dashing_state
	return null

func process_physics(delta: float) -> State:
	super(delta)
	animations.flip_h = parent.velocity.x/absf(parent.velocity.x) < 0
	print("\nCurrent State: ", get_state_name())
	print("\nCurrent acceleration: ", parent.current_acceleration)
	print("\nCurrent deceleration: ", parent.current_deceleration)
	print("\nCurrent horizontal velocity: ", parent.velocity.x)
	print("\nCurrent vertical velocity: ", parent.velocity.y)
	# Falling state when moving down
	if parent.velocity.y > 0:
		return falling_state
		
	# Stick to walls
	if parent.is_on_wall_only():
		return wall_sticking_state
		
	if parent.just_hit:
		return hurt_state
	return null
	
func process_frame(delta: float) -> State:
	#If dead, die
	if !parent.is_alive:
		return dead_state
	return null
