extends Control

func _ready():
	$Overlay/PauseMenu/RetryButton.connect("pressed", self, "_on_Retry_pressed")
	$Overlay/PauseMenu/MainButton.connect("pressed", self, "_on_Main_pressed")
	$Overlay/PauseMenu/QuitButton.connect("pressed", self, "_on_Quit_pressed")
	
func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		print(new_pause_state)
		visible = new_pause_state

func _on_Retry_pressed():
	get_tree().paused = not get_tree().paused
	get_tree().reload_current_scene()
	
func _on_Main_pressed():
	get_tree().paused = not get_tree().paused
	get_tree().change_scene("res://HomeScreen/HomeScreen.tscn")
	
func _on_Quit_pressed():
	get_tree().quit()
