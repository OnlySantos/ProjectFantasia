extends KinematicBody

onready var inventory = $PlayerUI/Inventory/Slots_Inv
onready var raycast = $head/raycast
var inv_open : bool

var move_speed : int = 20
var velocity : Vector3
var gravity : float = 100.0
var jump_velocity : int

const BASE_DMG = 1
var damage : int

var reset_position : Vector3
var gold : int = 0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inv_open = inventory.visible
	print("--- Debugging process started ---\nGodot Engine v3.2.1.stable.official - https://godotengine.org\nOpenGL ES 3.0 Renderer: Quadro K2200/PCIe/SSE2\n")
	print(deg2rad(15))
func position_reset():
	if is_on_floor():
		reset_position = global_transform.origin

	if translation.y <= -30:
		global_transform.origin = reset_position

func apply_motion(delta):
	#print(velocity)
	var move_x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var move_z = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))

	velocity.y -= gravity * delta
	var vel_y = velocity.y
	velocity = (transform.basis.x * move_x * move_speed) + (transform.basis.z * move_z * move_speed)
	velocity.y = vel_y

	velocity = move_and_slide(velocity, Vector3.UP, true, 4, 0.0, false)#0.261799, false)


