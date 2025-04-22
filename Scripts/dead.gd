extends State

signal dead
var finished: bool

func enter() -> void:
	parent.can_move = false
	finished = false

func process_physics(delta: float) -> State:
	if !parent.is_on_floor() and !finished:
		animations.play("freefall")
	elif !finished:
		animations.play("death", 0.5)
		finished = true
	
	dead.emit()
	return null
