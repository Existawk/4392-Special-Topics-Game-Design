extends Area2D


func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if get_overlapping_bodies().size() > 0:
			var next_level = int(get_tree().current_scene.name) + 1
			if next_level == 2:
				get_tree().change_scene("res://Level2.tscn")
			if next_level == 3:
				get_tree().change_scene("res://level3.tscn")
			if next_level == 4:
				get_tree().change_scene("res://level4.tscn")
			if next_level == 5:
				get_tree().change_scene("res://level5.tscn")
			if next_level == 6:
				get_tree().change_scene("res://HomeScreen/HomeScreen.tscn")
		else:
			print("too far")
