extends KinematicBody2D


const SHURIKEN = preload("res://Projectile/Shuriken.tscn")
signal health_updated(health)
signal killed()

export(float) var MAX_HEALTH = 100 
export(float) var REGEN_RATE = 0.05
onready var health = MAX_HEALTH setget _set_health

var input_vector = Vector2.ZERO
var velocity = Vector2()
var SPEED = 250
var GRAV = 15.0
const WALLJUMP_VEL = Vector2(2000,-400)
var is_jumping
var wallDirection = 1
var JUMP_IMPULSE = -550
onready var wall_slide_timer = $Timer
onready var melee_timer = $Timer2
onready var left_wall_raycasts = $wallRays/left
onready var right_wall_raycasts = $wallRays/right
onready var shuriken_position = $Shuriken
onready var anim_player = $AnimatedSprite
onready var invinc_timer = $invinc_timer
onready var regen_timer = $Regen_Timer
onready var HP_BAR = $Control
onready var MELEE_HIT_RIGHT = $RightHitBox/Melee_Hitbox
onready var MELEE_HIT_LEFT = $LeftHitBox/Melee_Hitbox2
var damaged = false
var PLAYER_DIR = 1


func _ready():
	HP_BAR._on_health_updated(health)
# EXIT AFTER PRESSING ESC
func _process(delta):
	if Input.is_action_just_pressed("key_exit"):
		get_tree().quit()
	if(regen_timer.is_stopped()):
		if(health < MAX_HEALTH):
			regen(REGEN_RATE)

# WALL DETECTION AND DETECTS WHERE WHICH WALL 1 FOR RIGHT WALL -1 FOR LEFT WALL
func update_wall_direction():
	var is_valid_left = check_wall(left_wall_raycasts)
	var is_valid_right = check_wall(right_wall_raycasts)
	
	if is_valid_left && is_valid_right:
		wallDirection = input_vector.x
	else:
		wallDirection = -int(is_valid_left) + int(is_valid_right)

# CHECK IF DETECTED A WALL
func check_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding(): 
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI * 0.35 && dot < PI *0.55:
				return true
	return false

#PERFORMS WALL JUMP
func wall_jump():
	var jump_vel = WALLJUMP_VEL
	jump_vel.x *= -wallDirection
	velocity += jump_vel

func apply_gravity():
	velocity.y += GRAV 

func cap_gravity():
	var max_vel = 100 if !Input.is_action_pressed("ui_down") else 200
	velocity.y = max_vel

func  apply_movement():
	if is_jumping && velocity.y >= 0:
		is_jumping = false	
	velocity = move_and_slide(velocity,Vector2.UP) 
	
	velocity.x = lerp(velocity.x,0,ret_h_value())
# RETURNS H VALUE FOR LERP
func ret_h_value():
	if is_on_floor():
		return 0.2
	else:
		if input_vector.x == 0:
			return 0.02
		elif input_vector.x == sign(velocity.x) && abs(velocity.x) > SPEED:
			return 0.0
		else:
			return 0.1


# GETS INPUT FOR CONTROLLER
func player_movement():
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
func getPlayerInput():
	velocity.x = input_vector.x * SPEED


func _on_Slash_area_entered(area):
	if area.is_in_group("hurtbox"):
		area.take_damage()

func regen(amount):
	_set_health(health + amount)


func damage(amount):
	_set_health(health - amount)
	regen_timer.start()
	
func kill():
	pass
#    get_tree().change_scene("res://GameOver/GameOver.tscn")

func _set_health(val):
	var prev_health = health
	health = clamp(val,0,MAX_HEALTH)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health == 0:
			kill()
			emit_signal("killed")
	HP_BAR._on_health_updated(health)



func _on_RightHitBox_body_entered(body: Node) -> void:
	if "SkeletonEnemy" in body.name:
		body.death()


func _on_LeftHitBox_body_entered(body: Node) -> void:
	if "SkeletonEnemy" in body.name:
		body.death()
