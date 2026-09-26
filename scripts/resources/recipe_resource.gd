class_name RecipeData extends Resource

@export var customer_dialog_options : Array[String]
@export var required_ingredients : Dictionary[String,float]
@export var bonus_scoring_ingedients : Dictionary[String,float]

func get_random_dialog () -> String:
	customer_dialog_options.shuffle()
	return customer_dialog_options[0]

func check_order_success ():
	var required_ingredients_remaining : Dictionary[String,float] = required_ingredients.duplicate()
	var cup_contents : Dictionary[String,float] = CupContents.contents
	
	for ingredient in cup_contents:
		var ingredient_quantity = cup_contents[ingredient]
		if required_ingredients_remaining.has(ingredient) and ingredient_quantity >= required_ingredients_remaining[ingredient]:
			pass
