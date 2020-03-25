extends StaticBody

export var health : int = 10
export var required_tool : String
export var Name : String = "BaseObject"
export var pickup : String = "None"
export var byproduct : String

func collect(inventory , equipped_tool , modifier , damage):
	if equipped_tool == required_tool:
		#randomize()
		health -= damage
		var amount = int(rand_range(0,2 * modifier))
		if amount < 1:
			amount = 0

		if amount > 0:
			inventory.give({pickup:amount})

		print(amount," ",pickup,"(s) ; " ,"dmg:", damage , " ; mod:",modifier , " ; hp:",health, " ; collected by " , inventory.get_parent().get_parent().name)

		if health <= 0:
			print("place byproduct")
			queue_free()
	else:
		print("not the right tool")





