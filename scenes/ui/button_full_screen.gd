extends TextureButton


var is_full_screen_on: bool = false
@onready var full_screen_label: Label = $FullScreenLabel


func _ready() -> void:
	is_full_screen_on = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	update_full_screen_state()


func _on_pressed() -> void:
	is_full_screen_on = not is_full_screen_on
	update_full_screen_state()
	grab_focus()


func _on_mouse_entered() -> void:
	grab_focus()


func update_full_screen_state():
	if is_full_screen_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		full_screen_label.text = "Full screen: on" 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		full_screen_label.text = "Full screen: off"
	
	button_pressed = is_full_screen_on
