extends TextureButton


@onready var game_pause_scene = $"../.."


func _on_pressed():
	game_pause_scene.is_game_paused = false
	release_focus()
