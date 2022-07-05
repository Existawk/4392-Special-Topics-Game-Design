extends KinematicBody2D

var FACING_RIGHT = true
var velocity = Vector2.ZERO
const THROW_VEL = 8
func _ready():
	pass


func _physics_process(delta):
	translate(velocity)
	rotate(PI/10)
	if($RayCast2D.is_colliding() or $RayCast2D2.is_colliding() or $RayCast2D3.is_colliding()):
		queue_free()		

func launch(direction):
	velocity.x = THROW_VEL * direction
 # Called when the node enters the scene tree for the first time.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Hitbox_body_entered(body: Node) -> void:
	if "SkeletonEnemy" in body.name:
		body.death()
		self.queue_free()
