extends Node2D

var attack_damage: float = 10.0
var knockback: float = 100

func _on_hitbox_area_entered(area):
	if area is HitboxComponent:
		var hitbox: HitboxComponent = area
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback
		attack.attack_position = global_position
		
		hitbox.damage(attack)
