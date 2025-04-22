extends Area2D

@onready var game_manager: Node = %"Game Manager"
@onready var animation: AnimationPlayer = $AnimationPlayer
@export var coin_value: float

func _on_body_entered(body: Node2D) -> void:
	game_manager.add_coins(coin_value)
	animation.play("pickup")
