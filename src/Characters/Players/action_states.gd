extends StateMachine

func _ready():
	add_state("none")
	add_state("attack")
	add_state("collect")
	add_state("pickup")
	call_deferred("set_state" , states.none)

#func state_logic(delta):
#	pass

# warning-ignore:unused_argument
func get_transition(delta):
	match state:
		states.none:
			if Input.is_action_just_pressed("action1") and can_collect():
				return states.collect
			if Input.is_action_just_pressed("pickup") and can_pickup():
				return states.pickup
			if Input.is_action_just_pressed("action1") and !can_collect():
				return states.attack
		states.collect:
			return states.none
		states.pickup:
			return states.none
		states.attack:
			return states.none

# warning-ignore:unused_argument
func enter_state(new_state, old_state):
	match new_state:
		states.none:
			pass
		states.collect:
			if parent.inventory.equipped_tool:
				parent.collider.collect(parent.inventory , parent.inventory.equipped_tool[0] ,  parent.inventory.equipped_tool[1] , parent.inventory.equipped_tool[2])
			else:
				print("no tool")
		states.pickup:
			pass
		states.attack:
			pass

func can_collect() -> bool:
	if parent.collider:
		if parent.collider.get_groups().has("resource"):
			var main_states = parent.state_machine.states
			return ![main_states.search].has(parent.state_machine.state)
	return false

func can_pickup() -> bool:
	if parent.collider:
		if parent.collider.get_groups().has("pickup"):
			var main_states = parent.state_machine.states
			return ![main_states.search].has(parent.state_machine.state)
	return false


