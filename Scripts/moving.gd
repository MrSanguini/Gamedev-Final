extends State

@export
var stationary_state: State

func enter() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null
	
func process_physics(delta: float) -> State:
	if parent.gravity_mod >= 1:
		if parent.velocity.y > 0:
			parent.gravity_mod = 1.7
		else:
			parent.gravity_mod = 1
	parent.velocity.y += parent.gravity * delta * parent.gravity_mod
	
	if parent.is_alive and parent.can_move:
		if get_movement_input() != 0:
			# Set direction faced and accelerate
			parent.turn = get_movement_input()
			parent.velocity.x = move_toward(parent.velocity.x, get_movement_input() * 999, parent.current_acceleration)
	
	# Apply decelration at all times
	parent.velocity.x = move_toward(parent.velocity.x, 0, parent.current_deceleration)
	
	#if parent.velocity.x == 0:
		#return stationary_state
	
	parent.move_and_slide()
	return null
