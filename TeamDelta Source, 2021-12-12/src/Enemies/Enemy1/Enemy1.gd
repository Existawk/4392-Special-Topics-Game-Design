extends KinematicBody2D

var gravity = 10
var velocity = Vector2(0,0)
var dead = false
var is_moving_right = true

var speed = 32 

func _ready():
	$AnimationPlayer.play("walk")
	
func _process(_delta):
	move_character()
	detect_turn_around()
	if(dead):
		death()
	
func move_character():
	velocity.x = speed if is_moving_right else -speed
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)
		
func detect_turn_around():
	var collision = false
	
	if $raycast.is_colliding() or $raycast2.is_colliding() or $raycast3.is_colliding():
		collision = true
	
	if (collision and is_on_floor()):
#        print("Time to turn around")
		is_moving_right = !is_moving_right
		scale.x = -scale.x
		
		
func hit():
	$AttackDetector.monitoring = true
	
func end_of_hit():
	$AttackDetector.monitoring = false
	
func start_walk():
	$AnimationPlayer.play("walk")
	
	
func death():
	dead = true
	velocity.x = 0
	$AttackDetector/CollisionShape2D.disabled = true
	$PlayerDetector/CollisionShape2D.disabled = true
	$AnimationPlayer.play("Death")
	yield($AnimationPlayer, "animation_finished")
	self.queue_free()
	

func _on_PlayerDetector_body_entered(body: Node) -> void:
	if body.name == "MainPlayer":
		$AnimationPlayer.play("Attack")


func _on_AttackDetector_body_entered(body: Node) -> void:\
	if body.name == "MainPlayer":
		body.damage(50)
#    get_tree().change_scene("res://GameOver/GameOver.tscn")

func _on_Area2D_body_entered(body: Node) -> void:
	print(body.name)
