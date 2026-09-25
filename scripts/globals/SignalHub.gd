extends Node

signal add_ingredient (ingredient : String, quantity : float)

func emit_add_ingredient (ingredient : String, quantity : float) -> void:
	add_ingredient.emit(ingredient,quantity)
