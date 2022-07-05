extends StateMachine


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var anim_state = null

func _ready():
	parent.connect("killed",self,"transition_death_state")	
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("wall_slide")
	add_state("melee")
	add_state("death")
	call_deferred("set_state",states.idle)


func transition_death_state():
	set_state(states.death)

func _state_logic(delta):
	parent.player_movement()
	parent.update_wall_direction()
	parent.apply_movement()
	parent.getPlayerInput()
	parent.apply_gravity()
	if state == states.wall_slide:
		parent.cap_gravity()



func _input(event):
	if[states.idle,states.run].has(state):
		if event.is_action_pressed("jump") && parent.is_on_floor():
			parent.velocity.y = parent.JUMP_IMPULSE
			parent.is_jumping = true

	if state == states.wall_slide:
		if event.is_action_pressed("jump"):
			parent.wall_jump()
			set_state(states.jump)
			
	if event.is_action_pressed("throw"):
		$ShurikenAudio.play()
		var projectile = parent.SHURIKEN.instance()
		parent.PLAYER_DIR = 1 if !parent.anim_player.flip_h else -1
		projectile.launch(parent.PLAYER_DIR)
		parent.get_parent().add_child(projectile)
		projectile.global_position = parent.shuriken_position.global_position
		
		

	if event.is_action_pressed("melee") && parent.is_on_floor() && parent.melee_timer.is_stopped():
		set_state(states.melee)


func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >= 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >= 0:
					return states.fall
			elif parent.velocity.x ==0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
			elif parent.wallDirection != 0 && parent.wall_slide_timer.is_stopped():
				return states.wall_slide
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
			elif parent.wallDirection != 0 && parent.wall_slide_timer.is_stopped():
				return states.wall_slide
		states.wall_slide:
			if parent.is_on_floor():
				return states.idle
			elif parent.wallDirection == 0 :
				return states.fall
		states.melee:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >= 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.death:
			parent.velocity.x = 0
			parent.velocity.y = 0
	return null

func _enter_state(new_state, prev_state):
	parent.MELEE_HIT_RIGHT.disabled = true
	parent.MELEE_HIT_LEFT.disabled = true
	match new_state:
		states.idle:
			$RunAudio.stop()
			parent.anim_player.play("Idle")
		states.jump:
			$RunAudio.stop()
			$JumpAudio.play()
			parent.anim_player.play("Jump")
			if(parent.velocity.x > 0):
				parent.anim_player.play("Jump")
				parent.anim_player.flip_h = false
			elif(parent.velocity.x < 0):
				parent.anim_player.play("Jump")
				parent.anim_player.flip_h = true			
		states.run:
			if(parent.velocity.x > 0):
				if parent.is_on_floor():
					$RunAudio.play()
				parent.anim_player.play("Run")
				parent.anim_player.flip_h = false
			elif(parent.velocity.x < 0):
				if parent.is_on_floor():
					$RunAudio.play()
				parent.anim_player.play("Run")
				parent.anim_player.flip_h = true
		states.wall_slide:
			$RunAudio.stop()
			parent.anim_player.flip_h = true if parent.wallDirection == 1 else false
			parent.anim_player.play("Jump")
		states.fall:
			$RunAudio.stop()
			if(parent.velocity.x > 0):
				parent.anim_player.play("Run")
				parent.anim_player.flip_h = false
			elif(parent.velocity.x < 0):
				parent.anim_player.play("Run")
				parent.anim_player.flip_h = true
		states.death:
			parent.anim_player.play("Death")
			yield(parent.anim_player, "animation_finished")
			get_tree().change_scene("res://GameOver/GameOver.tscn")
		states.melee:
			if $MeleeAudio.playing == false:
				$MeleeAudio.play()

			if(parent.anim_player.flip_h):
				parent.MELEE_HIT_LEFT.disabled = false				
			else:
				parent.MELEE_HIT_RIGHT.disabled = false
			parent.anim_player.play("Attack1")

func _exit_state(old_state, new_state):
	match old_state:
		states.wall_slide:
			parent.wall_slide_timer.start()
		states.melee:
			parent.melee_timer.start()
			set_state(states.idle)


func _on_AnimatedSprite_animation_finished():
	if (parent.anim_player.animation == "Attack1"):
		set_state(states.idle)
