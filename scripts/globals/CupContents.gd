extends Node

var contents : Dictionary = {}

var max_capacity : float = 100.0
var capacity : float = 0.0

func _ready() -> void:
	SignalHub.add_ingredient.connect(on_ingredient_added)

func on_ingredient_added(ingredient_name : String, quantity : float) -> void:
	if capacity == max_capacity: 
		print("Full!!")
		return
	
	var max_add = quantity if capacity + quantity <= max_capacity else max_capacity - capacity
	capacity += max_add
	
	print(capacity)
	
	if contents.has(ingredient_name):
		contents[ingredient_name] += max_add
	else:
		contents[ingredient_name] = max_add
