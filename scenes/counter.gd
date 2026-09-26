extends Node2D

var customer_id = "Kiwi"
var drink = "Hot Chocolate"
var cup = "cup holder necklace"

var ordertaken = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$OrderUI/Panel/Takeorder.text = "Take order"
	update_order()
	
func update_order():
	$"OrderUI/Panel/Customer id".text = "Customer:\n"+ customer_id
	$"OrderUI/Panel/Order text".text = "Drink:\n" + drink
	$"OrderUI/Panel/Cup text".text = "Cup:\n"+ cup
	

func _on_takeorder_pressed() -> void:
	ordertaken = true
	$OrderUI/Panel/Takeorder.text = "Order taken!"
	$OrderUI/Panel/Takeorder.disabled = true
