class_name Dispenser extends StaticBody2D

@onready var pour_cast: RayCast2D = $PourCast
@onready var cooldown: Timer = $Cooldown
@onready var pour_sound: AudioStreamPlayer2D = $PourSound
@onready var begin_pour_sound: AudioStreamPlayer2D = $BeginPourSound
@onready var pour_particles: CPUParticles2D = $PourParticles

@export_subgroup("Configuration")
@export var ingredient_name : String = "Unknown" #Used to determine what's added to the cup
@export var add_quantity : float = 5.0 #How much of the cup's capacity (of 100) each drop will fill

var is_pouring : bool = false

func begin_pour () -> void:
	is_pouring = true
	pour_particles.emitting = true
	
	if begin_pour_sound.stream: # If there is a sound to play, play
		begin_pour_sound.play()

func end_pour () -> void:
	is_pouring = false
	pour_particles.emitting = false
	pour_sound.stop()

func pour () -> void:
	if !cooldown.is_stopped(): return # Nice little cooldown
	cooldown.start()
	SignalHub.emit_add_ingredient(ingredient_name,add_quantity)
	
	if pour_sound.stream and !pour_sound.playing: # If there is a sound to play, play
		pour_sound.play()

func _physics_process(_delta: float) -> void:
	if pour_cast.is_colliding() and !is_pouring:
		begin_pour()
	elif pour_cast.is_colliding() and is_pouring:
		pour()
	elif !pour_cast.is_colliding() and is_pouring:
		end_pour()
