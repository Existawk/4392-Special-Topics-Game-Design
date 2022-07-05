extends Label

signal appear_finished

func GO_appear():
	$GOappear.play("GOappear")


func _on_GOappear_animation_finished(anim_name):
	emit_signal("appear_finished")
