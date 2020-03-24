extends Node

const ITEMS = {
	"stick" : {
		"name" : "Stick",
		"icon" : preload("res://src/assets/icons/stick.png"),
#		"object" : preload("res://Objects/PickupObjects/Stick.tscn") ,
		"stack_size" : 15
	},

	"rock" : {
		"name" : "Stone",
		"icon" : preload("res://src/assets/Icons/rock.png"),
#		"object" : preload("res://Objects/PickupObjects/Rock.tscn") ,
		"stack_size" : 15
	},

	"fiber" : {
		"name" : "Fiber",
		"icon" : preload("res://src/assets/Icons/fiber.png"),
#		"object" : preload("res://Objects/PickupObjects/FiberBundle.tscn") ,
		"stack_size" : 15
	},
	"axe_crude" : {
		"name" : "Crude Axe",
		"icon" : preload("res://src/assets/Icons/crude_axe.png"),
#		"object" : preload("res://Objects/PickupObjects/Axe.tscn") ,
		"stack_size" : 1
	},
		"pickaxe_crude" : {
		"name" : "Crude Axe",
		"icon" : preload("res://src/assets/Icons/crude_pickaxe.png"),
#		"object" : preload("res://Objects/PickupObjects/Axe.tscn") ,
		"stack_size" : 1
	},

	"error" : {
		"name" : "E",
		"icon" : preload("res://src/assets/Icons/error.png"),
		"stack_size" : 1
	}
}

const recipes = {
	["fiber","rock","stick"] : "axe_crude",
	["fiber","rock","rock","stick"] : "pickaxe_crude",
	["log"] : "stick"
}

func get_item(item_id):
	if item_id in ITEMS:                         
		return ITEMS[item_id]
	else:                                                           
		return ITEMS["error"]

