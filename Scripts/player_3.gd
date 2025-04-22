class_name Player
extends CharacterBody2D

# Base stats
@export
var base_health: float = 100
@export
var base_stamina: float = 20
@export
var base_speed : float = 150.0
@export
var base_acceleration : float = 1000.0
@export
var base_deceleration : float = 1000.0
@export 
var motion_mod : float = 1.0 
@export 
var sprint_mod : float = 1.8
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export
var gravity_mod: float = 1

# Other stats
@export var jump_velocity : float = -300.0
var turn : int = 1
@export var max_jumps : int = 2

# Stats modified on each process
var current_speed: float
var current_acceleration: float
var current_deceleration: float
var jumps_remaining : int = max_jumps
var is_alive : bool = true
var can_move : bool = true
var can_attack : bool = true
var can_dash : bool = true
var just_hit: bool = false
var knockback: float
var dash_cooldown : float = 0.5
var max_dash_cooldown : float = 0.5

@onready
var movement_animations: AnimatedSprite2D = $movement_animations
@onready
var action_animations: AnimatedSprite2D = $action_animations
@onready
var attack_animations: AnimatedSprite2D = $attack_animations
@onready var game_manager: Node = %"Game Manager"


@onready
var movement_state_machine: Node = $movement_state_machine
@onready
var action_state_machine: Node = $action_state_machine
@onready
var attack_state_machine: Node = $attack_state_machine
@onready
var player_move_component: Node = $player_move_component
@onready
var player_health_component: HealthComponent = $health_component
@onready
var player_hitbox_component: HitboxComponent = $hitbox_component
@onready
var player_collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	movement_state_machine.init(self, movement_animations, player_move_component, player_health_component, player_hitbox_component, player_collision)
	action_state_machine.init(self, action_animations, player_move_component, player_health_component, player_hitbox_component, player_collision)
	#attack_state_machine.init(self, attack_animations, player_move_component, player_health_component, player_hitbox_component, player_collision)

func _unhandled_input(event: InputEvent) -> void:
	movement_state_machine.process_input(event)
	action_state_machine.process_input(event)
	#attack_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)
	action_state_machine.process_physics(delta)
	#print("\nCurrent State: ", action_state_machine.current_state.get_state_name())
	#print("\nCurrent acceleration: ", current_acceleration)
	#print("\nCurrent deceleration: ", current_deceleration)
	#print("\nCurrent horizontal velocity: ", velocity.x)
	#print("\nCurrent vertical velocity: ", velocity.y)
	#attack_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)
	action_state_machine.process_frame(delta)
	#attack_state_machine.process_frame(delta)

# Getters
func get_current_movement_state() -> String:
	return movement_state_machine.get_current_state_name()
	
func get_current_action_state() -> String:
	return action_state_machine.get_current_state_name()
	
#func get_current_attack_state():
	#return attack_state_machine.get_current_state_name()

func _on_dead_dead() -> void:
	game_manager.game_over()
