extends TextureButton


var is_vsync_on: bool = false
@onready var vsync_label: Label = $VsyncLabel


func _ready() -> void:
	is_vsync_on = DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED
	update_vsync_state()


func _on_pressed() -> void:
	is_vsync_on = not is_vsync_on
	update_vsync_state()
	grab_focus()


func _on_mouse_entered() -> void:
	grab_focus()


func update_vsync_state():
	if is_vsync_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		vsync_label.text = "VSync: on"
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		vsync_label.text = "VSync: off"
	
	button_pressed = is_vsync_on
