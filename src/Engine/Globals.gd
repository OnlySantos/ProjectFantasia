extends Node

#name
#(optional) [tool_type , resource_modifier , damage]
#preload(<path to icon>)
#preload(<path to object>)
#max_stack_size


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
		"tool_info" : ["axe",1,3],
		"icon" : preload("res://src/assets/Icons/crude_axe.png"),
#		"object" : preload("res://Objects/PickupObjects/Axe.tscn") ,
		"stack_size" : 1
	},
		"pickaxe_crude" : {
		"name" : "Crude Axe",
		"tool_info" : ["pickaxe",1.1,3],
		"icon" : preload("res://src/assets/Icons/crude_pickaxe.png"),
#		"object" : preload("res://Objects/PickupObjects/Axe.tscn") ,
		"stack_size" : 1
	},
		"log" : {
		"name" : "Log",
		"icon" : preload("res://src/assets/Icons/log.png"),
#		"object" : preload("res://Objects/PickupObjects/Axe.tscn") ,
		"stack_size" : 5
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

