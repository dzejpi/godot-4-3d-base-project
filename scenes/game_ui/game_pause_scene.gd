extends Node2D


var current_focus: String = "pause"
@onready var continue_game_button: TextureButton = $PauseButtons/ContinueGameButton
@onready var settings_button: TextureButton = $PauseButtons/SettingsButton
@export var settings_section: Node


var focus_positions: Dictionary = {
	"pause": 0.0,
	"settings": 1280.0
}


func _ready() -> void:
	unpause_game()


func _process(delta: float) -> void:
	if current_focus in focus_positions:
		var target_x = focus_positions[current_focus]
		if not is_equal_approx(position.x, target_x):
			position.x = lerp(position.x, target_x, 5 * delta)


func _input(_event) -> void:
	if Input.is_action_just_pressed("game_pause"):
		GlobalVar.toggle_game_pause()
		update_pause_state()


func update_pause_state() -> void:
	if !GlobalVar.is_game_over:
		if GlobalVar.is_game_paused:
			show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			continue_game_button.grab_focus()
		else:
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func unpause_game() -> void:
	GlobalVar.unpause_game()
	update_pause_state()


func change_focus(new_focus: String) -> void:
	current_focus = new_focus
	
	match(current_focus):
		"pause":
			settings_button.grab_focus()
		"settings":
			settings_section.resolve_proper_focus()


func go_back_from_settings() -> void:
	change_focus("pause")
