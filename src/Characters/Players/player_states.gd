extends StateMachine

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	add_state("search")
	call_deferred("set_state" , states.walk)

func state_logic(delta):

	if state != states.search:
		parent.apply_motion(delta)
	parent.position_reset()

# warning-ignore:unused_argument
func get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y > 0:
					return states.jump
				elif parent.velocity.y < 0:
					return states.fall
			elif parent.inv_open:
				return states.search
			elif abs(parent.velocity.x) > 0.1 or abs(parent.velocity.z) > 0.1:#!(parent.velocity.x < 0.01 and parent.velocity.x > -0.01) or !(parent.velocity.z < 0.01 and parent.velocity.z > -0.01):
				return states.walk
		states.walk:
			if !parent.is_on_floor():
				if parent.velocity.y > 0:
					return states.jump
				elif parent.velocity.y < 0:
					return states.fall
			elif parent.inv_open:
				return states.search
			elif parent.velocity.x == 0 and parent.velocity.z == 0:#(parent.velocity.x < 0.01 and parent.velocity.x > -0.01) and (parent.velocity.z < 0.01 and parent.velocity.z > -0.01):
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y <= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y > 0:
				return states.jump
		states.search:
			if !parent.inv_open:
				return states.idle

# warning-ignore:unused_argument
func enter_state(new_state,old_state):
	match new_state:
		states.idle:
			print("STATE: idle")
#			parent.anim_player.play("idle")
		states.walk:
			print("STATE: walk")
#			parent.anim_player.play("walk")
		states.jump:
			print("STATE: jump")
#			parent.anim_player.play("jump")
		states.fall:
			print("STATE: fall")
#			parent.anim_player.play("fall")
		states.search:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			parent.raycast.enabled = false
			print("STATE: opening inventory")

func exit_state(old_state,new_state):
	match old_state:
#		states.idle:
#			print("last_idle")
		states.search:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			parent.raycast.enabled = true
			close_inv()
			print("STATE: closing inventory")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if event.is_action_pressed("open_inv"):
		
		if [states.walk,states.idle].has(state):
			parent.inventory.visible = true
			parent.inv_open = true
		if state == states.search:
			parent.inventory.visible = false
			parent.inv_open = false
			

	if event is InputEventMouseMotion:
		if state != states.search:
			parent.rotate_y(-event.relative.x * 0.005)
			parent.get_node("head").rotate_x(-event.relative.y * 0.005)

func close_inv():
	for slot in parent.inventory.get_parent().crafting_slots:
		if slot.item:
			slot.quick_move()


