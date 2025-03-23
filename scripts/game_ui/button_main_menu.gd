extends TextureButton


var is_button_pressed: bool = false


func _process(_delta: float) -> void:
	if is_button_pressed and TransitionOverlay.is_transition_completed:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu_scene.tscn")


func _on_pressed() -> void:
	is_button_pressed = true
	TransitionOverlay.fade_in()
