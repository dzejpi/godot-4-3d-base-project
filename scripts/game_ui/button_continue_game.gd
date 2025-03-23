extends TextureButton


@export var game_pause_scene: Node


func _on_pressed() -> void:
	game_pause_scene.is_game_paused = false
	release_focus()
