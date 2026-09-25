extends Control

var start_tween
var quit_tween

# Variables to remember your custom editor sizes
var start_base_scale
var quit_base_scale

func _ready():
	# Save the sizes the moment the menu loads
	start_base_scale = $Start.scale
	quit_base_scale = $Quit.scale

func _on_start_mouse_entered():
	if start_tween:
		start_tween.kill()
	start_tween = create_tween()
	# Multiply your custom size by 1.05 to grow it by 5%
	start_tween.tween_property($Start, "scale", start_base_scale * 1.05, 0.2)

func _on_start_mouse_exited():
	if start_tween:
		start_tween.kill()
	start_tween = create_tween()
	# Return to your exact custom size
	start_tween.tween_property($Start, "scale", start_base_scale, 0.2)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://counter_scene.tscn") 

func _on_quit_mouse_entered():
	if quit_tween:
		quit_tween.kill()
	quit_tween = create_tween()
	quit_tween.tween_property($Quit, "scale", quit_base_scale * 1.05, 0.2)

func _on_quit_mouse_exited():
	if quit_tween:
		quit_tween.kill()
	quit_tween = create_tween()
	quit_tween.tween_property($Quit, "scale", quit_base_scale, 0.2)

func _on_quit_pressed():
	get_tree().quit()
