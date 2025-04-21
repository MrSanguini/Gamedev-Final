extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
 
# speed in pixels/sec
var speed = 500
var turn = 1 
 
func _physics_process(_delta):
	# setup direction of movement
	var direction = Input.get_vector("left", "right", "up", "down")
	# stop diagonal movement by listening for input then setting axis to zero
	if Input.is_action_pressed("right") || Input.is_action_pressed("left"):
		sprite.play("walk horizontal")
		direction.y = 0
		if direction.x > 0:
			turn = 1
		if direction.x < 0:
			turn = -1
		sprite.flip_h = turn < 0
		print(turn)
	elif Input.is_action_pressed("up") || Input.is_action_pressed("down"):
		direction.x = 0
		if direction.y > 0:
			sprite.play("walk down")
		if direction.y < 0:
			sprite.play("walk up")
	else:
		direction = Vector2.ZERO
		sprite.play("idle down")
	
	#normalize the directional movement
	direction = direction.normalized()
	# setup the actual movement
	velocity = (direction * speed)
	move_and_slide()
