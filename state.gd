class_name State
extends Node

@export
var animation_name: String
@export
var state_name: String

# Stats that are modified on each process
var decel_mod: float
var speed_scale: float = 1

var animations: AnimatedSprite2D
var move_component: Node
var health_component: HealthComponent
var hitbox_component: HitboxComponent
var parent: CharacterBody2D
var collision: CollisionShape2D

func enter() -> void:
	animations.position.x = 0
	animations.position.y = 0
	animations.rotation_degrees = 0
	animations.scale.x = 1
	animations.scale.y = 1
	animations.speed_scale = speed_scale
	animations.play(animation_name)
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null
	
func process_frame(delta: float) -> State:
	if health_component.health <= 0:
		parent.is_alive = false
	return null
	
func process_physics(delta: float) -> State:
	# Scaling deceleration with current velocity/top speed
	animations.flip_h = parent.turn < 0
	decel_mod = clampf(absf(parent.velocity.x/(parent.base_speed * parent.motion_mod)), 0.3, parent.motion_mod * parent.sprint_mod)
	decel_mod += clampf(((absf(parent.velocity.x) - (parent.base_speed * parent.motion_mod * parent.sprint_mod))/(parent.base_speed * parent.motion_mod * parent.sprint_mod) * 0.2), 0, 999) # If the player is moving above top speed, decelerate back down to top speed slowly
	parent.current_deceleration = parent.base_deceleration * parent.motion_mod * delta * decel_mod
	
	# Reset dash
	if parent.dash_cooldown > -1:
		parent.dash_cooldown -= delta
	return null
	
func get_movement_input() -> float:
	return move_component.get_movement_direction()
	
func get_jump() -> bool:
	return move_component.wants_jump()
	
func get_jump_hold() -> bool:
	return move_component.holding_jump()
	
func get_dash() -> bool:
	return move_component.wants_dash()
	
func get_sprint() -> bool:
	return move_component.holding_sprint()

func get_state_name() -> String:
	return state_name
	
func set_collision(position_x: float, position_y: float, body_rotation: float, scale_x: float, scale_y: float) -> void:
	collision.position.x = position_x
	collision.position.y = position_y
	collision.rotation_degrees = body_rotation
	collision.scale.x = scale_x
	collision.scale.y = scale_y
