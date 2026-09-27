extends Node2D

var ordertaken = false 
var current_customer = 0

var customers : Array[Dictionary] = [
	{
		"id": "Kiwi",
		"texture": "res://assets/visuals/customers/kiwi.png",
		"texture_scale": 0.2
	},
	{
		"id": "Fennec Fox",
		"texture": "res://assets/visuals/customers/mole.png",
		"texture_scale": 0.2
	},
	{
		"id": "Mole",
		"texture": "res://assets/visuals/customers/mole.png",
		"texture_scale": 0.35
	}
]

var possible_drinks : Array[String] = [
	"res://resources/recipes/hot_cocoa.tres",
	"res://resources/recipes/mocha.tres",
	"res://resources/recipes/black_coffee.tres",
	"res://resources/recipes/flat_white.tres"
]

@onready var customer_id: Label = $"OrderUI/BAR/Customer id"
@onready var order_text: Label = $"OrderUI/BAR/Order text"
@onready var takeorder: Button = $OrderUI/BAR/Takeorder
@onready var placeholder: Button = $OrderUI/BAR/placeholder
@onready var dialogue_text: Label = $OrderUI/SpeechBubble/DialogueText

@onready var speech_bubble: NinePatchRect = $OrderUI/SpeechBubble

@onready var animal: Sprite2D = $Animal
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	untake_order()
	
	#disable the new customer button at the start and generate the first customer
	_on_placeholder_pressed()
	update_order()

func drink_served () -> void:
	pass

func update_order():
	var customer = customers[current_customer]
	possible_drinks.shuffle()
	var recipe_for_order : RecipeData = load(possible_drinks[0]) #customer["recipe"]
	PlayerStatus.current_order = recipe_for_order
	
	customer_id.text = customer["id"]
	order_text.text = recipe_for_order.drink_name #customer["drink"]
	dialogue_text.text = recipe_for_order.get_random_dialog() #customer["dialogue"]
	#print("Updated dialogue to: ", dialogue_text.text)

func _on_takeorder_pressed() -> void:
	take_order()

func customer_enter () -> void:
	#after that swap the customer sprites
	animal.texture = load(customers[current_customer]["texture"])
	animal.scale = Vector2(customers[current_customer]["texture_scale"],customers[current_customer]["texture_scale"])

	#then play the walk in animation
	animation_player.play("Walk_in")
	await animation_player.animation_finished
	speech_bubble.show()

func customer_leave () -> void:
	animation_player.play("Walk_out")

func change_customer() -> void:
	var previous_customer = current_customer
	
	while current_customer == previous_customer and customers.size() > 1:
		current_customer = customers.find(customers[randi_range(0,customers.size() - 1)])

func take_order () -> void:
	ordertaken = true
	takeorder.text = "Order taken!\n ✓ Active order"
	takeorder.disabled = true
	
	placeholder.disabled = false
	update_order()

func untake_order () -> void:
	ordertaken = false
	takeorder.text = "Take order"
	takeorder.disabled = false
	placeholder.disabled = true

func _on_placeholder_pressed() -> void: # "new customer" button
	speech_bubble.hide()
	customer_leave()
	await animation_player.animation_finished
	change_customer()
	customer_enter()
	
	untake_order()





	#
	##update dialouge 
	#
	#update_order()
	#
	##play walk out animation
	#animation_player.play("Walk_out")
	#await animation_player.animation_finished
	#
	##after that swap the customer sprites
	#print(customers[current_customer])
	#animal.texture = load(customers[current_customer]["texture"])
	#animal.scale = Vector2(customers[current_customer]["texture_scale"],customers[current_customer]["texture_scale"])
	#
	##then play the walk in animation
	#animation_player.play("Walk_in")
	#await animation_player.animation_finished
	#
	##then lock the button for new customers
	#placeholder.disabled = true
