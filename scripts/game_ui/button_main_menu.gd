extends TextureButton


var is_button_pressed = false


func _process(_delta):
	if is_button_pressed:
		if transition_overlay.transition_completed:
			get_tree().change_scene_to_file("res://scenes/ui/main_menu_scene.tscn")


func _on_pressed():
	is_button_pressed = true
	transition_overlay.fade_in()
