extends KinematicBody

onready var inventory = $PlayerUI/Inventory
onready var raycast = $head/raycast
onready var state_machine = $states
var collider = null

var base_speed : int = 15
var speed_mod : int
var velocity : Vector3

var gravity : float
var max_jump_velocity
var min_jump_velocity
var max_jump_height = 3.15
var min_jump_height = 0.8
var jump_duration = 0.5

const BASE_DMG = 1
#var equipped_tool = null
#var damage : int

var reset_position : Vector3
var gold : int = 0

var inv_open : bool
var is_jumping = false


func _ready():
	set_gravity()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inv_open = inventory.get_node("Slots_Inv").visible

func set_gravity():
	gravity = 2 * max_jump_height / pow(jump_duration,2)
	max_jump_velocity = sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = sqrt(2 * gravity * min_jump_height)

func position_reset():
	if is_on_floor():
		reset_position = global_transform.origin

	if translation.y <= -30:
		global_transform.origin = reset_position

func apply_motion(delta):
	#print(velocity)
	var move_x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var move_z = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
	var shift = Input.is_action_pressed("shift")
	var crouch = Input.is_action_pressed("crouch")

	if is_jumping and velocity.y <= 0:
		is_jumping = false

	if shift:
		speed_mod = 15
	elif crouch:
		speed_mod = -10
	else:
		speed_mod = 0

	velocity.y -= gravity * delta
	var vel_y = velocity.y
	velocity = (transform.basis.x * move_x * (base_speed + speed_mod)) + (transform.basis.z * move_z * (base_speed + speed_mod))
	velocity.y = vel_y

	velocity = move_and_slide(velocity, Vector3.UP) #, true, 4, 0.0, false) #0.261799, false)

func check_raycast():
	if raycast.get_collider():
		collider = raycast.get_collider()

		if collider.has_method("collect"):
			pass#print("COLLECT FROM " , collider.Name)

		elif collider.has_method("pickup"):
			pass#print("PICKUP " , collider.Name)

#		else:
#			print(raycast.get_collider().name)

	else:
		collider = null

