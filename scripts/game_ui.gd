extends CanvasLayer

@onready var in_kitchen: Control = $InKitchen
@onready var at_counter: Control = $AtCounter
@onready var clear_cup_sound: AudioStreamPlayer = $ClearCupSound
@onready var score: Label = $Both/MarginContainer/Score

@onready var serve_drink: Button = $InKitchen/MarginContainer2/ServeDrink
@onready var clear_cup: Button = $InKitchen/MarginContainer3/ClearCup

@export var kitchen : Node2D
@export var counter : Node2D

func _ready() -> void:
	SignalHub.cup_capacity_changed.connect(check_cup_capacity)
	check_cup_capacity()
	
	if kitchen.visible:
		_on_enter_kitchen_pressed()
	elif counter.visible:
		_on_return_to_counter_pressed()

func enter_kitchen () -> void:
	in_kitchen.show()
	at_counter.hide()

func enter_counter () -> void:
	in_kitchen.hide()
	at_counter.show()

func _on_return_to_counter_pressed() -> void:
	if !counter.visible:
		SignalHub.emit_enter_counter()
	
	kitchen.hide()
	counter.show()
	enter_counter()

func _on_enter_kitchen_pressed() -> void:
	if !kitchen.visible:
		SignalHub.emit_enter_kitchen()
	
	kitchen.show()
	counter.hide()
	enter_kitchen()

func _on_serve_drink_pressed() -> void:
	#CupContents.check_order_success(PlayerStatus.current_order)
	SignalHub.emit_serve_drink()
	_on_return_to_counter_pressed()

func check_cup_capacity () -> void:
	serve_drink.visible = CupContents.capacity >= CupContents.min_serve_capacity
	clear_cup.visible = !is_zero_approx(CupContents.capacity)

func _on_clear_cup_pressed() -> void:
	clear_cup_sound.play()
	CupContents.clear_cup()
