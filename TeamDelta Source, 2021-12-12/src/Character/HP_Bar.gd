extends Control
onready var updateTween

onready var health_bar = $TextureProgress
onready var health_bar_under = $Under
onready var update_tween = $UpdateTween
export (Color) var danger_color = Color.red
export (Color) var caution_color = Color.yellow
export (Color) var healthy_color = Color.green

export(float,0,1,0.05) var caution = 0.5
export(float,0,1,0.05) var danger = 0.2
func _on_health_updated(health):
	health_bar.value = health
	update_tween.interpolate_property(health_bar_under,"value",health_bar_under.value,health,0.4,Tween.EASE_IN_OUT)
	update_tween.start()
	
	_assign_color(health)
func _assign_color(health):
	if health < health_bar.max_value * danger:
		health_bar.tint_progress = danger_color
	elif health < health_bar.max_value * caution:
		health_bar.tint_progress = caution_color
	else:
		health_bar.tint_progress = healthy_color
func _on_max_health_updated(max_health):
	health_bar.max_value


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
