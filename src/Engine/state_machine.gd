extends Node
class_name StateMachine

var state = null setget set_state
var prev_state = null
var states = {}

# warning-ignore:unused_class_variable
onready var parent = get_parent()

func _physics_process(delta):
	if state != null:
		state_logic(delta)
		var transition = get_transition(delta)
		if transition != null:
			set_state(transition)

# warning-ignore:unused_argument
func state_logic(delta):
	pass

# warning-ignore:unused_argument
func get_transition(delta):
	return null

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func enter_state(new_state, old_state):
	pass

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func exit_state(old_state, new_state):
	pass

func set_state(new_state):
	prev_state = state
	state = new_state
	if prev_state != null:
		exit_state(prev_state,new_state)
	if new_state != null:
		enter_state(new_state,prev_state)

func add_state(state_name):
	states[state_name] = states.size()

