class_name Ingredient extends RigidBody2D
signal clicked

@onready var pour_cast: RayCast2D = $PourCast
@onready var cooldown: Timer = $Cooldown
@onready var pour_sound: AudioStreamPlayer2D = $PourSound
@onready var pour_particles: CPUParticles2D = $PourParticles

@export_subgroup("Configuration")
@export var ingredient_name : String = "Unknown" #Used to determine what's added to the cup
@export var add_quantity : float = 5.0 #How much of the cup's capacity (of 100) each drop will fill
@export var ingredient_weight : float = 20.0 #When thrown, the ingedient's velocity will be divided by this
@export var ingredient_pouring_radians : float = 1.0 #The angle the ingredient will begin pouring its contents at while held.
@export var rotation_step : float = 0.05
#@export var rogue_pouring : bool = false # Does it pour even when it's just been left on its side?

var held : bool = false
var in_tip_zone : bool = false
var current_hold_offset : Vector2 = Vector2.ZERO

func pour(is_into_cup : bool) -> void:
	if !cooldown.is_stopped(): return # Nice little cooldown
	cooldown.start()
	pour_particles.emitting = true
	
	if is_into_cup:
		SignalHub.emit_add_ingredient(ingredient_name,add_quantity)
	
	if pour_sound.stream and !pour_sound.playing: # If there is a sound to play, play
		pour_sound.play()

func rotate_to_target_radian(target_radian : float) -> void:
	global_rotation += rotation_step if global_rotation < target_radian else -rotation_step
	if !in_tip_zone and ((global_rotation < rotation_step and global_rotation > target_radian) or (global_rotation > rotation_step and global_rotation < target_radian)):
		global_rotation = target_radian

#region Drag Physics

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(self)

func _physics_process(_delta) -> void:
	if !held: return
	
	global_transform.origin = get_global_mouse_position() + current_hold_offset
	
	if in_tip_zone and pour_cast.is_colliding():
		pour(true)
	
	if !is_zero_approx(global_rotation) and !in_tip_zone: #Reset to upright if not in place where we want to tip ingredients.
		rotate_to_target_radian(0.0)
	elif in_tip_zone:
		rotate_to_target_radian(ingredient_pouring_radians)

func pickup() -> void:
	if held: return
	
	#Switch to the layer "ActiveIngredient" so cup can detect it.
	set_collision_layer_value(2,false)
	set_collision_layer_value(3,true)
	
	z_index += 5
	pour_particles.z_index -= 5
	
	current_hold_offset = global_transform.origin - get_global_mouse_position()
	freeze = true
	held = true

func drop(impulse : Vector2) -> void:
	if !held: return 
	
	#Switch to the layer "Ingredient" so cup can't detect it.
	set_collision_layer_value(2,true)
	set_collision_layer_value(3,false)
	
	z_index -= 5
	pour_particles.z_index += 5
	
	freeze = false
	held = false
	lock_rotation = false
	apply_central_impulse(impulse/ingredient_weight)

#endregion
