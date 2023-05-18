extends TextureButton


@onready var transition_overlay_scene = $"../../Overlay/TransitionOverlayScene"
var is_button_pressed = false


func _process(_delta):
	if is_button_pressed:
		if transition_overlay_scene.time_out > 1:
			get_tree().change_scene_to_file("res://scenes/ui/MainMenuScene.tscn")


func _on_pressed():
	is_button_pressed = true
	transition_overlay_scene.time_out = 0
	transition_overlay_scene.is_fading_out = false
