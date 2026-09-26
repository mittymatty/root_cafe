extends Node2D

var customer_id = "Kiwi"
var drink = "Hot Chocolate"
var cup = "cup holder necklace"

var ordertaken = false 

var customers = [
	{
		"id": "Kiwi",
		"drink": "Hot Chocolate",
		"cup": "Cup Holder Necklace"
	},
	{
		"id": "Fennec Fox",
		"drink": "cocoa",
		"cup": "Mug"
	},
	{
		"id": "Mole",
		"drink": "Coffee",
		"cup": "Travel cup"
	},
]

var current_customer = 0

func _ready() -> void:
	$OrderUI/Panel/Takeorder.text = "Take order"
	update_order()
	$OrderUI/Panel/placeholder.disabled = true
	
func update_order():
	var customer = customers[current_customer]
	$"OrderUI/Panel/Customer id".text = "Customer:\n"+ customer["id"]
	$"OrderUI/Panel/Order text".text = "Drink:\n" + customer["drink"]
	$"OrderUI/Panel/Cup text".text = "Cup:\n"+ customer["cup"]
	

func _on_takeorder_pressed() -> void:
	ordertaken = true
	$OrderUI/Panel/Takeorder.text = "Order taken!"
	$OrderUI/Panel/Takeorder.disabled = true
	$OrderUI/Panel/Takeorder.text += "\n\n ✓ Active order"

func _on_placeholder_pressed() -> void:
	current_customer += 1
	if current_customer >= customers.size():
		current_customer = 0
	ordertaken = false
	$OrderUI/Panel/Takeorder.text = "Take order"
	$OrderUI/Panel/Takeorder.disabled = false

	update_order()
