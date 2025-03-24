extends TextureButton


@export var game_pause_scene: Node


func _on_pressed() -> void:
	game_pause_scene.unpause_game()
	release_focus()
