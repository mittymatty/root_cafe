extends StaticBody2D
@onready var tipping_zone: Area2D = $TippingZone

var current_ingredient_pouring : Ingredient = null

func _on_tipping_zone_body_entered(body: Node2D) -> void:
	if !body is Ingredient: return
	current_ingredient_pouring = body
	current_ingredient_pouring.in_tip_zone = true

func _on_tipping_zone_body_exited(body: Node2D) -> void:
	if !body is Ingredient: return
	if body == current_ingredient_pouring:
		current_ingredient_pouring.in_tip_zone = false
		current_ingredient_pouring = null

func _physics_process(_delta: float) -> void:
	#print(current_ingredient_pouring)
	pass
