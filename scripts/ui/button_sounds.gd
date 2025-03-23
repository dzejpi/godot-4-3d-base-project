extends TextureButton


@onready var sounds_label: Label = $SoundsLabel
@onready var sounds_bus: int = AudioServer.get_bus_index("Sound")

var is_sound_on: bool = true


func _ready() -> void:
	is_sound_on = not AudioServer.is_bus_mute(sounds_bus)
	update_sound_state()


func _on_pressed() -> void:
	is_sound_on = not is_sound_on
	update_sound_state()


func update_sound_state() -> void:
	AudioServer.set_bus_mute(sounds_bus, not is_sound_on)
	
	if is_sound_on:
		sounds_label.text = "Sounds: on"
	else:
		sounds_label.text = "Sounds: off"
	
	button_pressed = is_sound_on
	release_focus()
