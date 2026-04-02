extends Node2D


@onready var main_menu_button: TextureButton = $GameWonButtons/MainMenuButton
@onready var quit_game_button: TextureButton = $GameWonButtons/QuitGameButton


func _ready() -> void:
	hide()


func show_game_won() -> void:
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	main_menu_button.grab_focus()
