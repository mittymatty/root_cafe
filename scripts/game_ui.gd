extends CanvasLayer

@onready var in_kitchen: Control = $InKitchen
@onready var at_counter: Control = $AtCounter

@export var kitchen : Node2D
@export var counter : Node2D

func enter_kitchen () -> void:
	in_kitchen.show()
	at_counter.hide()

func enter_counter () -> void:
	in_kitchen.hide()
	at_counter.show()

func _on_return_to_counter_pressed() -> void:
	kitchen.hide()
	counter.show()
	enter_counter()

func _on_enter_kitchen_pressed() -> void:
	kitchen.show()
	counter.hide()
	enter_kitchen()

func _ready() -> void:
	if kitchen.visible:
		_on_enter_kitchen_pressed()
	elif counter.visible:
		_on_return_to_counter_pressed()
