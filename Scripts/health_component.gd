extends Node
class_name HealthComponent

@onready
var parent = get_parent()

var max_health: float
var health: float
var missing_health: float
var percent_health: float

func _ready() -> void:
	max_health = parent.base_health
	health = max_health
	missing_health = max_health - health
	percent_health = (health/max_health) * 100


func damage(attack: Attack):
	health -= attack.attack_damage
	missing_health = max_health - health
	percent_health = (health/max_health) * 100
