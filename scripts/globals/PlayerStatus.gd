extends Node

var current_order : RecipeData = null
var score : int = 0
var happy_customers_today : int = 0
var max_customers_in_day : int = 10

var customers_left_in_day : int = max_customers_in_day

const END_SCREEN = "res://scenes/UI/end_screen.tscn"


func _ready() -> void:
	happy_customers_today = 0
	customers_left_in_day = max_customers_in_day
	SignalHub.change_customer_count.connect(on_customer_count_changed)

func on_customer_count_changed () -> void:
	if customers_left_in_day == 0:
		SignalHub.emit_day_end()
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file(END_SCREEN)
