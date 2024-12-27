extends TextureButton

@onready var music_label = $MusicLabel
var is_music_on = true


func _ready():
	if AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")):
		is_music_on = false
		music_label.text = "Music: off"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		button_pressed = false
		release_focus()
	else:
		is_music_on = true
		music_label.text = "Music: on"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		button_pressed = true
		release_focus()


func _on_pressed():
	if is_music_on:
		is_music_on = false
		music_label.text = "Music: off"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		button_pressed = false
		release_focus()
	else:
		is_music_on = true
		music_label.text = "Music: on"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		button_pressed = true
		release_focus()
