extends Node2D


@onready var main_menu_button: TextureButton = $GameOverButtons/MainMenuButton
@onready var quit_game_button: TextureButton = $GameOverButtons/QuitGameButton


func _ready() -> void:
	hide()


func show_game_over() -> void:
	show()
	GlobalVar.is_game_over = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	main_menu_button.grab_focus()
