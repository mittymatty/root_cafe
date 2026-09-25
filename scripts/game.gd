extends Node2D

var held_ingredient : Ingredient = null

func _ready():
	for node in get_tree().get_nodes_in_group("draggable_ingredients"):
		#print(node)
		node.clicked.connect(on_pickable_clicked)

func on_pickable_clicked(object):
	if held_ingredient: return
	object.pickup()
	held_ingredient = object

func _unhandled_input(event):
	if event is InputEvent and event.as_text() == "R":
		get_tree().reload_current_scene()
	
	if held_ingredient and get_has_mouse_released(event): #Just to shorten things a little I checked conditions in a separate function :D
		held_ingredient.drop(Input.get_last_mouse_velocity())
		held_ingredient = null

func get_has_mouse_released (event) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed
