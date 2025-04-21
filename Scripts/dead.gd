extends State

signal dead

func enter() -> void:
	super()

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		animations.play("freefall")
	else:
		animations.play("death")
	
	dead.emit()
	return null
