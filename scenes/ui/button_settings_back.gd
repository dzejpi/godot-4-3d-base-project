extends TextureButton


@export var settings_scene: Node


func _on_pressed() -> void:
	settings_scene.dismiss_settings()


func _on_mouse_entered() -> void:
	grab_focus()
