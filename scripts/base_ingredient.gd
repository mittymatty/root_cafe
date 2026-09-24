class_name Ingredient extends RigidBody2D
signal clicked

@export var ingredient_weight : float = 20.0 #When thrown, the ingedients velocity will be divided by this
var held : bool = false
var in_tip_zone : bool = false
var current_hold_offset : Vector2 = Vector2.ZERO
var rotation_step : float = 0.06

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(self)

func _physics_process(_delta):
	if !held: return
	global_transform.origin = get_global_mouse_position() + current_hold_offset
	if !is_zero_approx(global_rotation) and !in_tip_zone: #Reset to upright if not in place where we want to tip ingredients.
		global_rotation += rotation_step if global_rotation < 0 else -rotation_step
		if (global_rotation < rotation_step and global_rotation > 0.0) or (global_rotation > rotation_step and global_rotation < 0.0):
			global_rotation = 0.0

func pickup():
	if held: return
	current_hold_offset = global_transform.origin - get_global_mouse_position()
	freeze = true
	held = true

func drop(impulse : Vector2):
	if !held: return 
	freeze = false
	held = false
	lock_rotation = false
	apply_central_impulse(impulse/ingredient_weight)
