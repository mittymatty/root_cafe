extends Node2D

var ordertaken = false 
var current_customer = 0

var customers = [
	{
		"id": "Kiwi",
		"drink": "Hot Chocolate",
		"dialogue": "I'm feeling a bit chilly,\n I'd like a chocolatey one today please!"
	},
	{
		"id": "Fennec Fox",
		"drink": "cocoa",
		"dialogue": "Just the usual.\n cocoa for me, thanks."
	},
	{
		"id": "Mole",
		"drink": "Coffee",
		"dialogue": "Need something to keep me awake on the go.\n Dark and strong."
	}
]

func _ready() -> void:
	$OrderUI/Panel/Takeorder.text = "Take order"
	$OrderUI/Panel/placeholder.disabled = true
	update_order()
	
func update_order():
	var customer = customers[current_customer]
	$"OrderUI/BAR/Customer id".text = customer["id"]
	$"OrderUI/BAR/Order text".text = customer["drink"]
	$"OrderUI/Panel/DialogueText".text = customer["dialogue"]
	
func _on_takeorder_pressed() -> void:
	ordertaken = true
	$OrderUI/Panel/Takeorder.text = "Order taken!\n\n ✓ Active order"
	$OrderUI/Panel/Takeorder.disabled = true
	
	$OrderUI/Panel/placeholder.disabled = false

func _on_placeholder_pressed() -> void:
	var previous_customer = current_customer
	
	while current_customer == previous_customer:
		current_customer = randi_range(0, customers.size() - 1)
	
	ordertaken = false
	$OrderUI/Panel/Takeorder.text = "Take order"
	$OrderUI/Panel/Takeorder.disabled = false
	
	$OrderUI/Panel/placeholder.disabled = true
	
	update_order()
