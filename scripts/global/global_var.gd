extends Node


@onready var music_node = $MusicPlayer
@onready var sfx_node = $SfxPlayer

# Necessary to replace null with a proper preload("res://...")
var music_game_music = null

# Necessary to replace null with a proper preload("res://...")
var sfx_sound_placeholder = null


func play_music():
	music_node.stream = music_game_music
	music_node.play()


func stop_music():
	music_node.stop()


func play_sound(sfx_name):
	match(sfx_name):
		"placeholder":
			sfx_node.stream = sfx_sound_placeholder
			sfx_node.play()


func stop_sound(sfx_name):
	match(sfx_name):
		"placeholder":
			sfx_node.stream = sfx_sound_placeholder
			sfx_node.stop()
