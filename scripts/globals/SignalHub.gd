extends Node

signal add_ingredient (ingredient : String, quantity : float)

signal cup_capacity_changed

signal enter_kitchen

signal enter_counter

signal serve_drink

func emit_add_ingredient (ingredient : String, quantity : float) -> void:
	add_ingredient.emit(ingredient,quantity)

func emit_cup_capacity_changed () -> void:
	cup_capacity_changed.emit()

func emit_enter_kitchen () -> void:
	enter_kitchen.emit()

func emit_enter_counter () -> void:
	enter_counter.emit()

func emit_serve_drink () -> void:
	serve_drink.emit()
