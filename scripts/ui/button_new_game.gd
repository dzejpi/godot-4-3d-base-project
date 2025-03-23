extends TextureButton


var is_button_pressed: bool = false


func _process(_delta: float) -> void:
	if is_button_pressed and TransitionOverlay.is_transition_completed:
		get_tree().change_scene_to_file("res://scenes/game/game_scene.tscn")


func _on_pressed() -> void:
	TransitionOverlay.fade_in()
	is_button_pressed = true
