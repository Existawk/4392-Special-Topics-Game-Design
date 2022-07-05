extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var detect_radius
export (float) var DMG = 0.25
var vis_color = Color(0.867,0.91,0.247,0.1)
var laser_color = Color(1.0, .329, .298)
var target
var hit_pos
var can_shoot = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.self_modulate = Color(0.2,0,0)
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visibility/CollisionShape2D.shape = shape
func _physics_process(delta):
	update()
	if target:
		aim()

func aim():
	hit_pos = []
	$Sprite.self_modulate = Color(0.2,0,0)
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.name == "MainPlayer":
				$Sprite.self_modulate.r = 1.0
				rotation = (target.position - position).angle()
				result.collider.damage(DMG)
				break
func _draw():
	draw_circle(Vector2(),detect_radius,vis_color)
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Visibility_body_entered(body):
	if target:
		return
	print(body.name)
	target = body


func _on_Visibility_body_exited(body):
	if body == target:
		target = null
		$Sprite.self_modulate.r = 0.2
