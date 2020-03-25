extends Control
class_name Inventory

var inventory_slots = []
var crafting_slots = []
var recipe = []
var output : TextureRect
var byproduct : TextureRect

var held_item = null
var hold_offset = Vector2(-25,-25)
var can_drop = false
var equipped_tool = null
var selection = 1
onready var selected = $Slots_Quickbar.get_child(selection)
const sel_offset = -2

func _ready():
	create_slots()
	give({"rock" : 5 , "stick" : 3 , "fiber":3,"axe_crude":1})

func create_slots():
	for inventory in get_children():
		if inventory.name.begins_with("Slots_"):
			for slot in inventory.get_children():
				if slot.name.begins_with("Slot_"):
#					slot.connect("mouse_entered", self, "mouse_enter_slot", [slot])
#					slot.connect("mouse_exited", self, "mouse_exit_slot", [slot])
					slot.connect("gui_input", self, "slot_gui_input", [slot])
					slot.script = preload("res://src/UI/ItemSlot.gd")
					if slot.name.begins_with("Slot_I"):
						slot.set_type("DEFAULT")
					if slot.name.begins_with("Slot_C"):
						slot.set_type("CRAFTING")
						crafting_slots.append(slot)
					if slot.name.begins_with("Slot_Q"):
						slot.set_type("QUICKBAR")
					if slot.name.begins_with("Slot_O"):
						slot.set_type("OUTPUT")
						output = slot
					if slot.name.begins_with("Slot_W"):
						slot.set_type("WASTE")
#					if slot.name.begins_with("Slot_E"):
#						slot.set_type("EQUIPMENT_") # + EQUIP_MODIFY
					inventory_slots.append(slot)

func find_free_slot(item):
	for slot in inventory_slots:
		if slot.type == "DEFAULT":
			if slot.is_free(item):
				return slot
		elif slot.type == "QUICKBAR":
			if slot.is_free(item):
				return slot
	return null

func give(arr):
	if arr is Dictionary:
		for item in arr:
			for _i in range(arr[item]):
				var slot = find_free_slot(item)
				if slot:
					slot.add_item(item)
				else:
					print("no space for " , item) ### drop mechanic

	elif arr is String:
		var slot = find_free_slot(arr)
		if slot:
			slot.add_item(arr)

	update_tool()

func check_crafting():
	recipe = []

	if output.item:
		output.remove_child(output.item[1])
		output.item = null

	for slot in crafting_slots:
		if slot.item:
			recipe.append(slot.item[0])
	recipe.sort()

	for recipes in Globals.recipes:
		if recipe == recipes:
			output.add_item(Globals.recipes[recipe])

func complete_craft():
	for slot in crafting_slots:
		if slot.item:
			slot.item[2] -= 1
			if slot.item[2] == 0:
				slot.remove_child(slot.item[1])
				slot.item = null
			slot.check_amount()
	check_crafting()

func slot_gui_input(event , slot):
	var left_click = event.is_action_released("action1")
	var right_click = event.is_action_released("action2")
	var shift = Input.is_action_pressed("shift")

	if event is InputEventMouseButton:
		update_tool()
		if slot.type != "OUTPUT" and slot.type != "WASTE":                # # # DOES NOT WORK FOR "OUTPUT" SLOTS # # #
			if left_click:
				if held_item:
					if slot.item:
						if slot.item[0] == held_item[0]:
							slot.combine_stacks(held_item)
						else:
							slot.swap_stacks(held_item)
					else:
						slot.place_stack(held_item)
				elif !held_item:
					if slot.item:
						if shift:
							for _i in range(0,slot.item[2]):
								if slot.item:
									slot.quick_move()
								else:
									return
						else:
							slot.pick_stack()
			elif right_click:
				if held_item:
					slot.place_one(held_item)
				else:
					if slot.item:
						slot.pick_half()

			if slot.type == "CRAFTING":
				if left_click or right_click:
					check_crafting()

		if (slot.type == "OUTPUT" or slot.type == "WASTE"):                # # # ONLY WORKS FOR "OUTPUT" SLOTS # # #
			if slot.item:                                                           # # SLOT HAS ITEM # #
				if !held_item:                                                      # # NOT HOLDING ITEM # #
					if left_click:                                                  # [-] PICK STACK [-] #
						if shift:
							slot.quick_move()
							complete_craft()
						else:
							slot.pick_stack()
							complete_craft()
					elif right_click:                                               # [-] PICK ONE [-] #
						slot.pick_stack()#slot.pick_one()
						complete_craft()

func _input(event):
	var scroll_up = event.is_action_released("scroll_up")
	var scroll_down = event.is_action_released("scroll_down")
#	var left_click = event.is_action_released("action1")

	if event is InputEventMouseMotion:
		if held_item:
			held_item[1].rect_position = get_global_mouse_position() + hold_offset

	if scroll_up or scroll_down:
		if scroll_up:
			if selection > 1:
				selection -= 1
			else:
				selection = 9

		if scroll_down:
			if selection < 9:
				selection += 1
			else:
				selection = 1
		$Slots_Quickbar/Selection.rect_global_position = $Slots_Quickbar.get_child(selection).rect_global_position + Vector2(sel_offset,sel_offset)
		selected = $Slots_Quickbar.get_child(selection)
		update_tool()

		#print(selected.name)

#	if left_click:
#		if held_item:
#			if item_dropping:
#				drop_stack()

#		var mouse_pos = get_global_mouse_position()
#		if mouse_pos.x >= 0 and mouse_pos.x <= 1200:
##		if mouse_pos >= Vector2(0,0) and mouse_pos <= Vector2(1100,860):
#			item_dropping = false
#		else:
#			item_dropping = true
#			#print("droppable")


func update_tool():
	var quickslot = $Slots_Quickbar.get_child(selection)
	if quickslot.item:
		if Globals.get_item(quickslot.item[0]).has("tool_info"):
			print(Globals.get_item(quickslot.item[0])["tool_info"])
			equipped_tool = Globals.get_item(quickslot.item[0])["tool_info"]
			return
	equipped_tool = null
#	else:
#		print("no item type")
