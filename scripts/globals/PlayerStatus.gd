extends Node

var current_order : RecipeData = null
var score : int = 0
var max_customers_in_day : int = 10
var customers_left_in_day : int = max_customers_in_day

func _ready() -> void:
	customers_left_in_day = max_customers_in_day
