extends Node2D


func _ready() -> void:
	hide()


func show_game_over() -> void:
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
