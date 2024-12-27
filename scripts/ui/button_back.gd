extends TextureButton


@onready var main_menu_scene = $"../../.."


func _on_pressed():
	main_menu_scene.current_focus = "main_menu"
	release_focus()
