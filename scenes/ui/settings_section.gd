extends Node2D

@export var currently_selected: String = "audio"

# Buttons
@onready var game_switch_button: TextureButton = $SettingsSwitcher/GameSwitchButton
@onready var audio_switch_button: TextureButton = $SettingsSwitcher/AudioSwitchButton
@onready var graphics_switch_button: TextureButton = $SettingsSwitcher/GraphicsSwitchButton
@onready var controls_switch_button: TextureButton = $SettingsSwitcher/ControlsSwitchButton

# Sections
@onready var game_settings: Node2D = $SettingsContent/GameSettings
@onready var audio_settings: Node2D = $SettingsContent/AudioSettings
@onready var graphics_settings: Node2D = $SettingsContent/GraphicsSettings
@onready var controls_settings: Node2D = $SettingsContent/ControlsSettings


func _ready() -> void:
	currently_selected = "audio"
	update_switch()


func update_switch() -> void:
	game_switch_button.release_focus()
	audio_switch_button.release_focus()
	graphics_switch_button.release_focus()
	controls_switch_button.release_focus()
	
	game_switch_button.button_pressed = false
	audio_switch_button.button_pressed = false
	graphics_switch_button.button_pressed = false
	controls_switch_button.button_pressed = false
	
	game_settings.hide()
	audio_settings.hide()
	graphics_settings.hide()
	controls_settings.hide()
	
	match(currently_selected):
		"game":
			game_settings.show()
			game_switch_button.button_pressed = true
		"audio":
			audio_settings.show()
			audio_switch_button.button_pressed = true
		"graphics":
			graphics_settings.show()
			graphics_switch_button.button_pressed = true
		"controls":
			controls_settings.show()
			controls_switch_button.button_pressed = true
	
	resolve_proper_focus()


func resolve_proper_focus() -> void:
	match(currently_selected):
		"game":
			game_switch_button.grab_focus()
		"audio":
			audio_switch_button.grab_focus()
		"graphics":
			graphics_switch_button.grab_focus()
		"controls":
			controls_switch_button.grab_focus()


func _on_game_switch_button_pressed() -> void:
	currently_selected = "game"
	game_settings.show()
	update_switch()


func _on_audio_switch_button_pressed() -> void:
	currently_selected = "audio"
	audio_settings.show()
	update_switch()


func _on_graphics_switch_button_pressed() -> void:
	currently_selected = "graphics"
	graphics_settings.show()
	update_switch()


func _on_controls_switch_button_pressed() -> void:
	currently_selected = "controls"
	controls_settings.show()
	update_switch()


func _on_game_switch_button_mouse_entered() -> void:
	game_switch_button.grab_focus()


func _on_audio_switch_button_mouse_entered() -> void:
	audio_switch_button.grab_focus()


func _on_graphics_switch_button_mouse_entered() -> void:
	graphics_switch_button.grab_focus()


func _on_controls_switch_button_mouse_entered() -> void:
	controls_switch_button.grab_focus()
