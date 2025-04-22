extends Node

@onready var coins: int
@onready var player: Player = $"../Player"
@onready var death_menu: Control = $"../CanvasLayer/deathMenu"
@onready var money_bar: Control = $"../CanvasLayer/MoneyBar"

func add_coins(coin_value: int):
	coins += coin_value
	money_bar._on_money_changed(coins)
	print("added ", coin_value, " coins")
	
func game_over() -> void:
	death_menu.game_over()
