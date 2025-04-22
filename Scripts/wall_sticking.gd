extends State

@export
var wall_jumping_state: State
@export
var falling_state: State
@export
var dead_state: State
@export
var hurt_state: State

var wall_normal

func enter() -> void:
	super()
	parent.can_move = false
	set_collision(1, 18, 0, 0.5, 1.5)
	parent.velocity.x = 0
	parent.velocity.y = 0
	parent.gravity_mod = 0.6
	if parent.get_slide_collision(0) != null:
		wall_normal = parent.get_slide_collision(0).get_normal()
	
func process_input(event: InputEvent) -> State:
	if get_jump():
		return wall_jumping_state
	if Input.is_action_just_pressed('down'):
		return falling_state
	return null
	
func process_physics(delta: float) -> State:
	super(delta)
	animations.flip_h = wall_normal.x < 0
	parent.velocity.y = 0
	if !parent.is_on_wall_only():
		return falling_state
		
	if parent.just_hit:
		return hurt_state
	return null

func exit() -> void:
	parent.can_move = true
	parent.gravity_mod = 1
	
func process_frame(delta: float) -> State:
	#If dead, die
	if !parent.is_alive:
		return dead_state
	return null
	
	
