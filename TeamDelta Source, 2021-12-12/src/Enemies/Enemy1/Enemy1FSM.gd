extends StateMachine
#
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#
#
#func _ready():
#    add_state("attack")
#    add_state("hit")
#    add_state("idle")
#    add_state("walk")
#    add_state("death")
#    call_deferred("set_state",states.idle)
#
#func _state_logic(delta):
#    parent.player_movement()
#    parent.update_wall_direction()
#    parent.apply_movement()
#    parent.getPlayerInput()
#    parent.apply_gravity()
#    if state == states.wall_slide:
#        parent.cap_gravity()
#
#
#
#func _input(event):
#    if[states.idle,states.run].has(state):
#        if event.is_action_pressed("jump") && parent.is_on_floor():
#            parent.velocity.y = parent.JUMP_IMPULSE
#            parent.is_jumping = true
#    if state == states.wall_slide:
#        if event.is_action_pressed("jump"):
#            parent.wall_jump()
#            set_state(states.jump)
#
#
#func _get_transition(delta):
#    match state:
#        states.idle:
#            if !parent.is_on_floor():
#                if parent.velocity.y < 0:
#                    return states.jump
#                elif parent.velocity.y >= 0:
#                    return states.fall
#            elif parent.velocity.x != 0:
#                return states.run
#        states.run:
#            if !parent.is_on_floor():
#                if parent.velocity.y < 0:
#                    return states.jump
#                elif parent.velocity.y >= 0:
#                    return states.fall
#            elif parent.velocity.x ==0:
#                return states.idle
#        states.jump:
#            if parent.is_on_floor():
#                return states.idle
#            elif parent.velocity.y >= 0:
#                return states.fall
#            elif parent.wallDirection != 0 && parent.wall_slide_timer.is_stopped():
#                return states.wall_slide
#        states.fall:
#            if parent.is_on_floor():
#                return states.idle
#            elif parent.velocity.y < 0:
#                return states.jump
#            elif parent.wallDirection != 0 && parent.wall_slide_timer.is_stopped():
#                return states.wall_slide
#        states.wall_slide:
#            if parent.is_on_floor():
#                return states.idle
#            elif parent.wallDirection == 0 :
#                return states.fall
#    return null
#
#func _enter_state(new_state, prev_state):
#    match new_state:
#        states.idle:
#            parent.anim_player.play("Idle")
#        states.jump:
#            parent.anim_player.play("Jump")
#        states.run:
#            if(parent.velocity.x > 0):
#                parent.anim_player.play("RunRight")
#                parent.anim_player.flip_h = false
#            elif(parent.velocity.x < 0):
#                parent.anim_player.play("RunLeft")
#                parent.anim_player.flip_h = true
#        states.wall_slide:
#            parent.anim_player.flip_h = true if parent.wallDirection == 1 else false
#            parent.anim_player.play("Jump")
#
#
#
#func _exit_state(old_state, new_state):
#    match old_state:
#        states.wall_slide:
#            parent.wall_slide_timer.start()
#    pass
#
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
