class_name Ingredient extends RigidBody2D
signal clicked

@onready var pour_cast: RayCast2D = $PourCast

@export_subgroup("Configuration")
@export var ingredient_weight : float = 20.0 #When thrown, the ingedient's velocity will be divided by this
@export var ingredient_pouring_radians : float = 1.0 #The angle the ingredient will begin pouring its contents at while held.

var held : bool = false
var in_tip_zone : bool = false
var current_hold_offset : Vector2 = Vector2.ZERO
var rotation_step : float = 0.05

func pour() -> void:
	print("pouring") #Override this later

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(self)

func rotate_to_target_radian(target_radian : float) -> void:
	global_rotation += rotation_step if global_rotation < target_radian else -rotation_step
	if !in_tip_zone and ((global_rotation < rotation_step and global_rotation > target_radian) or (global_rotation > rotation_step and global_rotation < target_radian)):
		global_rotation = target_radian

#region Drag Physics

func _physics_process(_delta) -> void:
	if !held: return
	
	global_transform.origin = get_global_mouse_position() + current_hold_offset
	
	if in_tip_zone and pour_cast.is_colliding():
		pour()
	
	if !is_zero_approx(global_rotation) and !in_tip_zone: #Reset to upright if not in place where we want to tip ingredients.
		rotate_to_target_radian(0.0)
	elif in_tip_zone:
		rotate_to_target_radian(ingredient_pouring_radians)

func pickup() -> void:
	if held: return
	
	#Switch to the layer "ActiveIngredient" so cup can detect it.
	set_collision_layer_value(2,false)
	set_collision_layer_value(3,true)
	
	current_hold_offset = global_transform.origin - get_global_mouse_position()
	freeze = true
	held = true

func drop(impulse : Vector2) -> void:
	if !held: return 
	
	#Switch to the layer "Ingredient" so cup can't detect it.
	set_collision_layer_value(2,true)
	set_collision_layer_value(3,false)
	
	freeze = false
	held = false
	lock_rotation = false
	apply_central_impulse(impulse/ingredient_weight)

#endregion
