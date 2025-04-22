extends State

@export
var standing_state: State
@export
var dead_state: State
@export
var hurt_time : float = 0.25
var hurt_timer: float

signal hurt

func enter() -> void:
	super()
	parent.velocity.x = parent.knockback * -parent.turn
	if parent.velocity.y != 0:
		parent.velocity.y = -parent.knockback * (parent.velocity.y/absf(parent.velocity.y))
	hurt.emit()
	hitbox_component.iframe = true
	parent.just_hit = false
	hurt_timer = hurt_time
	parent.knockback = 0

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	super(delta)
	#If dead, die
	if !parent.is_alive: 
		return dead_state
	return null

func process_frame(delta: float) -> State:
	#If dead, die
	if !parent.is_alive:
		return dead_state
	hurt_timer -= delta
	if hurt_timer <= 0:
		return standing_state
	return null

func exit() -> void:
	hitbox_component.iframe = false
