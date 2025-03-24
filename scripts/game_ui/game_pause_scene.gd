extends Node2D


func _ready() -> void:
	unpause_game()


func _input(_event) -> void:
	if Input.is_action_just_pressed("game_pause"):
		GlobalVar.toggle_game_pause()
		update_pause_state()


func update_pause_state() -> void:
	if GlobalVar.is_game_paused:
		show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func unpause_game() -> void:
	GlobalVar.unpause_game()
	update_pause_state()
