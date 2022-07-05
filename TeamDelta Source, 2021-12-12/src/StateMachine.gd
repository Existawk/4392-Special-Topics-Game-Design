extends Node
class_name StateMachine

var state = null setget set_state
var prev_state = null
var states = {}
onready var parent = get_parent()

func _state_logic(delta):
	pass


func _physics_process(delta):
	if state != null:
		_state_logic(delta)
		var trans = _get_transition(delta)
		if trans != null:
			set_state(trans)

func _get_transition(delta):
	return null

func _enter_state(new_state, prev_state):
	pass
	
func _exit_state(old_state, new_state):
	pass
	
func set_state(new_state):
	prev_state = state
	state = new_state
	
	if prev_state != null:
		_exit_state(prev_state,new_state)
	if(new_state!= null):
		_enter_state(new_state,prev_state)

func add_state(state_name):
	states[state_name] = states.size()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
