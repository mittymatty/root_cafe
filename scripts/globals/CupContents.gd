extends Node

var contents : Dictionary[String,float] = {}

var max_capacity : float = 100.0
var capacity : float = 0.0
var min_serve_capacity : float = 10.0 #80.0

func _ready() -> void:
	SignalHub.add_ingredient.connect(on_ingredient_added)

func on_ingredient_added(ingredient_name : String, quantity : float) -> void:
	if capacity == max_capacity: return
	
	var max_add = quantity if capacity + quantity <= max_capacity else max_capacity - capacity
	capacity += max_add
	
	if contents.has(ingredient_name):
		contents[ingredient_name] += max_add
	else:
		contents[ingredient_name] = max_add
	
	print(contents)
	SignalHub.emit_cup_capacity_changed()

func clear_cup() -> void:
	contents.clear()
	capacity = 0.0
	SignalHub.emit_cup_capacity_changed()

func check_order_success (recipe : RecipeData) -> int:
	print(recipe)
	var ingredients_remaining : Dictionary[String,float] = recipe.required_ingredients.duplicate()
	var cup_contents : Dictionary[String,float] = CupContents.contents
	var max_score : int = ingredients_remaining.size()
	var score : int = 0
	
	for ingredient in cup_contents:
		var ingredient_quantity = cup_contents[ingredient]
		if ingredients_remaining.has(ingredient) and !is_zero_approx(ingredients_remaining[ingredient]) and ingredient_quantity >= ingredients_remaining[ingredient]:
			#print("Got ingredient ",ingredient, " correct, quantity needed: ",ingredients_remaining[ingredient],", quantity given: ",ingredient_quantity)
			score += 1
		#else:
			#print("Got ingredient ",ingredient, " incorrect, quantity needed: ",ingredients_remaining[ingredient],", quantity given: ",ingredient_quantity)
	
	print("Score: ", score,"/",max_score)
	return score
