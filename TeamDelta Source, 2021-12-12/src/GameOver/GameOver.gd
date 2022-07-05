extends Control

func _ready():
	$GO/GOappear.play("GOappear")

func _on_Button_pressed():
	get_tree().change_scene("res://HomeScreen/HomeScreen.tscn")


func _on_GO_appear_finished():
	pass # stop playing music here
