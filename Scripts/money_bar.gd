extends Control

@onready var label = $Label
var money_manager

func _ready():
	money_manager = get_node("/root/Money_Manager")
	if money_manager != null:
		money_manager.connect("money_changed", Callable(self, "_on_money_changed"))
		# Initialize label with current money
		label.text = str(money_manager.current_money)
	else:
		print("Error: MoneyManager node not found at /root/MoneyManager")

func _on_money_changed(amount: int) -> void:
	label.text = str(amount)
