extends Node
class_name StaminaComponent

@onready
var parent = get_parent()

var max_stamina: float
var stamina: float
var missing_stamina: float
var percent_stamina: float

func _ready() -> void:
	max_stamina = parent.base_stamina
	stamina = max_stamina
	missing_stamina = max_stamina - stamina
	percent_stamina = (stamina/max_stamina) * 100


func damage(attack: Attack) -> void:
	stamina -= attack.attack_damage
	missing_stamina = max_stamina - stamina
	percent_stamina = (stamina/max_stamina) * 100
