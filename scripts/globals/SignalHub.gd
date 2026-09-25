extends Node

signal add_ingredient (ingredient : String, quantity : float)

signal cup_capacity_changed

func emit_add_ingredient (ingredient : String, quantity : float) -> void:
	add_ingredient.emit(ingredient,quantity)


func emit_cup_capacity_changed () -> void:
	cup_capacity_changed.emit()
