class_name RecipeData extends Resource

@export var customer_dialog_options : Array[String]
@export var required_ingredients : Dictionary[String,float]
@export var bonus_scoring_ingedients : Dictionary[String,float]

func get_random_dialog () -> String:
	customer_dialog_options.shuffle()
	return customer_dialog_options[0]
