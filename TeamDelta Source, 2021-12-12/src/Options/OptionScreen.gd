extends Control

func _ready():
	
	$Options/MusicOption/MusicOnButton.connect("pressed", self, "_on_Music_on")
	$Options/MusicOption/MusicOffButton.connect("pressed", self, "_on_Music_off")
	$Options/CenterContainer/BackButton.connect("pressed", self, "_on_Button_pressed", [$Options/CenterContainer/BackButton.scene_to_load])
	for button in $Options/LevelSelection/Levels.get_children():
		button.connect("mouse_entered", self, "_on_Button_hovered", [button.scene_to_load])
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
		
func _on_Button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)

func _on_Button_hovered(scene_to_load):
	if scene_to_load == "res://Level1.tscn":
		$Options/LevelSelection/CenterContainer/TextureRect.texture = load("res://Options/backgroundsq/lv1bg.png")
	if scene_to_load == "res://Level2.tscn":
		$Options/LevelSelection/CenterContainer/TextureRect.texture = load("res://Options/backgroundsq/lv2bg.png")
	if scene_to_load == "res://level3.tscn":
		$Options/LevelSelection/CenterContainer/TextureRect.texture = load("res://Options/backgroundsq/lv3bg.png")
	if scene_to_load == "res://level4.tscn":
		$Options/LevelSelection/CenterContainer/TextureRect.texture = load("res://Options/backgroundsq/lv4bg.png")
	if scene_to_load == "res://level5.tscn":
		$Options/LevelSelection/CenterContainer/TextureRect.texture = load("res://Options/backgroundsq/lv5bg.png")

func _on_Music_on():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	
func _on_Music_off():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
