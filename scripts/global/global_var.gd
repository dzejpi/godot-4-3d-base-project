extends Node


@onready var music_node: AudioStreamPlayer = $MusicPlayer
@onready var sfx_node: AudioStreamPlayer = $SfxPlayer

# Assigned in Inspector
@export var music_game_music: AudioStream

# Replace null with a proper preload("res://...")
# Or delete fully and set everything through Inspector
@export var sfx_sounds: Dictionary = {
	"placeholder": null
}


func play_music() -> void:
	if music_game_music:
		music_node.stream = music_game_music
		music_node.play()


func stop_music() -> void:
	music_node.stop()


func play_sound(sfx_name: String) -> void:
	if sfx_name in sfx_sounds and sfx_sounds[sfx_name]:
		sfx_node.stream = sfx_sounds[sfx_name]
		sfx_node.play()


func stop_sound(sfx_name: String) -> void:
	if sfx_name in sfx_sounds and sfx_sounds[sfx_name]:
		sfx_node.stop()
