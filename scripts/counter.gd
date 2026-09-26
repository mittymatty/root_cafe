extends Node2D

var ordertaken = false 
var current_customer = 0

@onready var customer_id: Label = $"OrderUI/BAR/Customer id"
@onready var order_text: Label = $"OrderUI/BAR/Order text"
@onready var takeorder: Button = $OrderUI/BAR/Takeorder
@onready var placeholder: Button = $OrderUI/BAR/placeholder
@onready var dialogue_text: Label = $OrderUI/Panel/DialogueText

@onready var animal: Sprite2D = $Animal
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var customers = [
	{
		"id": "Kiwi",
		"drink": "Hot Chocolate",
		"dialogue": "I'm feeling a bit chilly,\n I'd like a chocolatey one today please!",
		#"texture": "example path"
	},
	{
		"id": "Fennec Fox",
		"drink": "cocoa",
		"dialogue": "Just the usual.\n cocoa for me, thanks.",
		#"texture": "example path"
	},
	{
		"id": "Mole",
		"drink": "Coffee",
		"dialogue": "Need something to keep me awake on the go.\n Dark and strong.",
		#"texture": "example path"
	}
]

func _ready() -> void:
	takeorder.text = "Take order"
	takeorder.disabled = false
	
	#disable the new customer button at the start and generate the first customer
	placeholder.disabled = true
	_on_placeholder_pressed()
	
	#update the order
	
	update_order()


func update_order():
	var customer = customers[current_customer]
	
	customer_id.text = customer["id"]
	order_text.text = customer["drink"]
	dialogue_text.text = customer["dialogue"]
	print("Updated dialogue to: ", customer["dialogue"])
	
func _on_takeorder_pressed() -> void:
	ordertaken = true
	takeorder.text = "Order taken!\n\n ✓ Active order"
	takeorder.disabled = true
	
	placeholder.disabled = false

func _on_placeholder_pressed() -> void:
	var previous_customer = current_customer
	
	while current_customer == previous_customer:
		current_customer = randi_range(0, customers.size() - 1)
	ordertaken = false
	takeorder.text = "Take order"
	takeorder.disabled = false
	placeholder.disabled = true
	#update dialouge 
	update_order()
	#play walk out animation
	animation_player.play("Walk_out")
	await animation_player.animation_finished
	#after that swap the customer sprites
	# $"PLACEHOLDER FOR ANIMALS".texture = load(customers[current_customer]["texture"])
	#then play the walk in animation
	animation_player.play("Walk_in")
	await animation_player.animation_finished
	#then lock the button for new customers
	placeholder.disabled = true
	
