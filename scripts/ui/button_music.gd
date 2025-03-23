extends TextureButton


@onready var music_label: Label = $MusicLabel
@onready var music_bus: int = AudioServer.get_bus_index("Music")

var is_music_on: bool = true


func _ready() -> void:
	is_music_on = not AudioServer.is_bus_mute(music_bus)
	update_music_state()


func _on_pressed() -> void:
	is_music_on = not is_music_on
	update_music_state()


func update_music_state() -> void:
	AudioServer.set_bus_mute(music_bus, not is_music_on)
	if is_music_on:
		music_label.text = "Music: on" 
	else:
		music_label.text = "Music: off"
	
	button_pressed = is_music_on
	release_focus()
