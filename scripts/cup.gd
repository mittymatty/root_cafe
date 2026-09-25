class_name Cup extends RigidBody2D
@onready var tipping_zone: Area2D = $TippingZone
signal clicked
var current_ingredient_pouring : Ingredient = null
var held : bool = false
var current_hold_offset : Vector2 = Vector2.ZERO



func _on_tipping_zone_body_entered(body: Node2D) -> void:
	if !body is Ingredient: return
	current_ingredient_pouring = body
	current_ingredient_pouring.in_tip_zone = true

func _on_tipping_zone_body_exited(body: Node2D) -> void:
	if !body is Ingredient: return
	if body == current_ingredient_pouring:
		current_ingredient_pouring.in_tip_zone = false
		current_ingredient_pouring = null

#region Drag Physics

func _physics_process(_delta: float) -> void:
	#print(current_ingredient_pouring)
	if !held: return
	global_transform.origin = get_global_mouse_position() + current_hold_offset

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(self)

func pickup() -> void:
	if held: return
	current_hold_offset = global_transform.origin - get_global_mouse_position()
	freeze = true
	held = true

func drop(impulse : Vector2) -> void:
	if !held: return 
	freeze = false
	held = false
	apply_central_impulse(impulse/100)

#endregion
