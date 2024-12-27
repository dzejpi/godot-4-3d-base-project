extends TextureButton

@onready var sounds_label = $SoundsLabel
var is_sound_on = true


func _ready():
	if AudioServer.is_bus_mute(AudioServer.get_bus_index("Sound")):
		is_sound_on = false
		sounds_label.text = "Sound: off"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), true)
		button_pressed = false
		release_focus()
	else:
		is_sound_on = true
		sounds_label.text = "Sound: on"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), false)
		button_pressed = true
		release_focus()


func _on_pressed():
	if is_sound_on:
		is_sound_on = false
		sounds_label.text = "Sound: off"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), true)
		button_pressed = false
		release_focus()
	else:
		is_sound_on = true
		sounds_label.text = "Sound: on"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"), false)
		button_pressed = true
		release_focus()
