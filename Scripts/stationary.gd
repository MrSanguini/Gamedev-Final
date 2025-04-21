extends State

@export
var moving_state: State

func enter() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if get_movement_input() != 0.0:
		return moving_state
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	parent.move_and_slide()
	return null
