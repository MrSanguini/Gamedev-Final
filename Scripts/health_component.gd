extends Node
class_name HealthComponent

@onready
var parent = get_parent()
@export
var healthbar: HealthBar

var max_health: float
var health: float
var missing_health: float
var percent_health: float

func _ready() -> void:
	max_health = parent.base_health
	health = max_health
	missing_health = max_health - health
	percent_health = (health/max_health) * 100
	healthbar.init_health(health)


func damage(attack: Attack) -> void:
	health -= attack.attack_damage
	missing_health = max_health - health
	percent_health = (health/max_health) * 100
	parent.knockback = attack.knockback_force
	healthbar.health = health
