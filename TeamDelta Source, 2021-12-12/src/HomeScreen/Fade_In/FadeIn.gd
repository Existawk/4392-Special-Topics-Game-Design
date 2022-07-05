extends ColorRect

signal fade_finished

func fade_in():
	$FadeIn.play("Fade_In")
	
func _on_FadeIn_animation_finished(anim_name):
	emit_signal("fade_finished")
