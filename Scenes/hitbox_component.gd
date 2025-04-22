extends Area2D
class_name HitboxComponent

@onready
var parent = get_parent()

@export
var health_component: HealthComponent

var iframe: bool = false

func damage(attack: Attack) -> void:
	if health_component and !iframe:
		health_component.damage(attack)
		parent.just_hit = true
