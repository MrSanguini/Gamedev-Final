extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func game_over() -> void:
	get_tree().paused = true
	show()

func _on_quit_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_2_pressed() -> void:
	pass # Replace with function body.
