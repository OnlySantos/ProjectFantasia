extends TextureRect


var inventory = get_tree().get_root().get_node("Main/Player/PlayerUI/Inventory")
var item_base = preload("res://src/UI/ItemBase.tscn").instance()
var type : String
var item = null
var slot_offset = Vector2()

func set_type(new_type):
	type = new_type

func add_item(added_item):                                                          # # # USED WHEN PICKING UP WORLD ITEMS OR IN A "GIVE" COMMAND # # #
	if item and item[0] == added_item:
		item[2] += 1
	else:
		var item_struct = Globals.get_item(added_item)
		self.item = [added_item , item_base.duplicate() , 1]
		item[1].texture = item_struct["icon"]
		add_child(item[1])
	check_amount()

func pick_stack():
	item[1].mouse_filter = MOUSE_FILTER_IGNORE
	remove_child(item[1])
	get_tree().get_root().add_child(item[1])
	inventory.held_item = item
	inventory.held_item[1].rect_size = Vector2(45,45)
	item = null
	inventory.held_item[1].rect_position = get_global_mouse_position()

func pick_half():
	var item_struct = Globals.get_item(item[0])
	var slot_amount = item[2] / 2
	var hand_amount = item[2] - slot_amount

	item[2] = slot_amount
	inventory.held_item = [item[0] , item_base.duplicate() , hand_amount]
	inventory.held_item[1].texture = item_struct["icon"]
	inventory.held_item[1].rect_position = get_global_mouse_position()
	inventory.held_item[1].mouse_filter = MOUSE_FILTER_IGNORE
	get_tree().get_root().add_child(inventory.held_item[1])

	if item[2] == 0:
		remove_child(item[1])
		item = null

	check_amount()
	check_hand_amount()

func pick_one():
	print("-to be implemented: pick_one()")

func place_stack(new_item):
	item = new_item
	item[1].rect_position = slot_offset
	
	item[1].mouse_filter = MOUSE_FILTER_PASS
	get_tree().get_root().remove_child(item[1])
	add_child(item[1])
	inventory.held_item = null

func place_one(new_item):
	if item:
		if item[0] == new_item[0] and item[2] < Globals.get_item(item[0])["stack_size"]:
			inventory.held_item[2] -= 1
			item[2] += 1
	elif !item:
		inventory.held_item[2] -= 1
		add_item(new_item[0])
	if new_item[2] == 0:
		get_tree().get_root().remove_child(new_item[1])
		inventory.held_item = null

	check_amount()
	check_hand_amount()

func swap_stacks(new_item):
	var temp_item = item                                                        # # SLOT BECOMES TEMP(OFFHAND) # #
	pick_stack()                                                                # # SLOT TO HAND(OFFHAND) # #
	temp_item[1].rect_position = get_global_mouse_position()
	place_stack(new_item)
	inventory.held_item = temp_item

func combine_stacks(new_item):
	if item[2] + new_item[2] <= Globals.get_item(item[0])["stack_size"]:
		get_tree().get_root().remove_child(inventory.held_item[1])
		item[2] += new_item[2]
		inventory.held_item = null
		item[1].mouse_filter = MOUSE_FILTER_PASS
	else:
		var fix_amount = Globals.get_item(item[0])["stack_size"] - item[2]
		item[2] += fix_amount
		inventory.held_item[2] -= fix_amount

	check_amount()
	check_hand_amount()

func quick_move():
	for slot in inventory.inventory_slots:
		if (type != "QUICKBAR" and slot.type == "QUICKBAR") or (type != "DEFAULT" and slot.type == "DEFAULT") or (type == "QUICKBAR" and slot.type == "DEFAULT"):
			if slot.item:
				if slot.item[0] == item[0] and slot.item[2] != Globals.get_item(slot.item[0])["stack_size"]:
					quick_combine(slot)
					return
			elif !slot.item:
				remove_child(item[1])
				slot.add_child(item[1])
				slot.item = item
				slot.item[1].rect_global_position = slot.rect_global_position
				item = null
				return
			else:
				print("no space to quick_move")
				return

func quick_combine(slot):
	if item[2] + slot.item[2] <= Globals.get_item(item[0])["stack_size"]:
		remove_child(item[1])
		slot.item[2] += item[2]
		item = null
	else:
		var fix_amount = Globals.get_item(item[0])["stack_size"] - slot.item[2]
		slot.item[2] += fix_amount
		item[2] -= fix_amount

	check_amount()
	slot.check_amount()

func check_amount():                                                            # # CHECKS SLOT ITEM LABELS AND AFFECTS ITEM ACCORDINGLY
	if item:
		var count = item[1].get_node("Count")
		count.text = str(item[2])
		if item[2] > 1:
			count.visible = true
		else:
			count.visible = false

func check_hand_amount():                                                       # # CHECKS PLAYER ITEM LABELS AND AFFECTS ITEM ACCORDINGLY
	if inventory.held_item:
		var count = inventory.held_item[1].get_node("Count")
		count.text = str(inventory.held_item[2])
		if inventory.held_item[2] > 1:
			count.visible = true
		else:
			count.visible = false

func is_free(added_item):
	if !item:
		return self

	elif item[0] == added_item and item[2] < Globals.get_item(added_item)["stack_size"]:
		return self




