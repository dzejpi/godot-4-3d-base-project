extends TextureButton


@export var main_menu_scene: Node


func _on_pressed() -> void:
	main_menu_scene.change_focus("main_menu")


func _on_mouse_entered() -> void:
	grab_focus()
