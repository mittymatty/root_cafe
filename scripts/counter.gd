extends Node2D

var ordertaken = false 
var current_customer = 0
var is_transitioning: bool = false

var customers : Array[Dictionary] = [
	{
		"id": "Kiwi",
		"texture": "res://assets/visuals/customers/kiwi.png",
		"texture_scale": 0.3
	},
	{
		"id": "Fennec Fox",
		"texture": "res://assets/visuals/icon.svg",
		"texture_scale": 1
	},
	{
		"id": "Mole",
		"texture": "res://assets/visuals/customers/mole.png",
		"texture_scale": 0.35
	}
]

var success_dialogs : Array[String] = [
	"That's perfect!",
	"Ahhh, lovely.",
	"This is just the way I like it!",
	"Thank you so much!"
]

var failure_dialogs : Array[String] = [
	"Hmm... I don't think I ordered that...",
	"Oh, I don't think this is right...",
	"Am I supposed to drink this?",
	"This drink doesn't feel right."
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

@onready var shop_bell: AudioStreamPlayer = $ShopBell
@onready var cash_register: AudioStreamPlayer = $CashRegister

@onready var animal: Sprite2D = $Animal
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	untake_order()
	change_customer()
	await customer_enter()
	update_order()
	
	SignalHub.serve_drink.connect(on_drink_served)

func on_drink_served () -> void:
	if is_transitioning:
		return
	is_transitioning = true
	
	var score = CupContents.check_order_success(PlayerStatus.current_order)
	var success : bool = false
	
	if score == PlayerStatus.current_order.required_ingredients.size():
		success_dialogs.shuffle()
		dialogue_text.text = success_dialogs[0]
		success = true
	else:
		failure_dialogs.shuffle()
		dialogue_text.text = failure_dialogs[0]
	
	CupContents.clear_cup()
	
	animation_player.play("talk")
	await animation_player.animation_finished
	
	if success:
		cash_register.play()
		SignalHub.emit_add_score(score * 10)
	
	#clear last order
	untake_order()
	await customer_leave()
	change_customer()
	await customer_enter()
	update_order()
	
	is_transitioning = false

func _on_takeorder_pressed() -> void:
	take_order()

func customer_enter () -> void:
	#after that swap the customer sprites
	animal.texture = load(customers[current_customer]["texture"])
	animal.scale = Vector2(customers[current_customer]["texture_scale"],customers[current_customer]["texture_scale"])

	#then play the walk in animation
	animation_player.play("Walk_in")
	shop_bell.play()
	await animation_player.animation_finished
	speech_bubble.show()

func customer_leave () -> void:
	speech_bubble.hide()
	animation_player.play("Walk_out")
	await animation_player.animation_finished
	animal.texture = null

func change_customer() -> void:
	var previous_customer = current_customer
	while current_customer == previous_customer and customers.size() > 1:
		current_customer = randi() % customers.size()

func take_order () -> void:
	ordertaken = true
	takeorder.text = "Order taken!\n ✓ Active order"
	takeorder.disabled = true
	placeholder.disabled = false

func untake_order () -> void:
	ordertaken = false
	takeorder.text = "Take order"
	takeorder.disabled = false
	placeholder.disabled = true
	customer_id.text = ""
	order_text.text = ""
	
	PlayerStatus.current_order = null
	speech_bubble.hide()

func update_order():
	var customer = customers[current_customer]
	possible_drinks.shuffle()
	var recipe_for_order : RecipeData = load(possible_drinks[0]) #customer["recipe"]
	PlayerStatus.current_order = recipe_for_order
	
	customer_id.text = customer["id"]
	order_text.text = recipe_for_order.drink_name #customer["drink"]
	dialogue_text.text = recipe_for_order.get_random_dialog() #customer["dialogue"]
	#print("Updated dialogue to: ", dialogue_text.text)

func _on_placeholder_pressed() -> void: # "new customer" button
	if is_transitioning:
		return
	is_transitioning = true
	
	#clear last order
	untake_order()
	await customer_leave()
	change_customer()
	await customer_enter()
	update_order()
	
	is_transitioning = false
