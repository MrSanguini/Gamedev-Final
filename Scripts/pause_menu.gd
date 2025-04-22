extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	hide()

func resume():
	get_tree().paused = false
	hide()
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	
func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()


func _on_resume_button_pressed() -> void:
	resume()

func _on_quit_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_2_pressed() -> void:
	pass # Replace with function body.

func _process(delta: float):
	testEsc()
