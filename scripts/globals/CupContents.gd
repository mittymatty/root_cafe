extends Node

var contents : Dictionary[String,float] = {}

var max_capacity : float = 100.0
var capacity : float = 0.0
var min_submit_capacity : float = 70.0

func _ready() -> void:
	SignalHub.add_ingredient.connect(on_ingredient_added)

func on_ingredient_added(ingredient_name : String, quantity : float) -> void:
	if capacity == max_capacity: 
		print("Full!!")
		return
	
	var max_add = quantity if capacity + quantity <= max_capacity else max_capacity - capacity
	capacity += max_add
	
	if contents.has(ingredient_name):
		contents[ingredient_name] += max_add
	else:
		contents[ingredient_name] = max_add
	
	print(contents)
	SignalHub.emit_cup_capacity_changed()
