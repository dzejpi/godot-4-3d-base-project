extends Node2D


var current_focus: String = "main_menu"
@onready var new_game_button: TextureButton = $MainMenuSection/MenuButtons/NewGameButton
@onready var settings_button: TextureButton = $MainMenuSection/MenuButtons/SettingsButton
@onready var credits_button: TextureButton = $MainMenuSection/MenuButtons/CreditsButton
@onready var back_button: TextureButton = $CreditsSection/BackButton/BackButton
@onready var settings_section: Node2D = $SettingsSection

var focus_positions: Dictionary = {
	"main_menu": 0.0,
	"credits": -1280.0,
	"settings": 1280.0
}


func _ready() -> void:
	TransitionOverlay.fade_out()
	new_game_button.grab_focus()


func _process(delta: float) -> void:
	if current_focus in focus_positions:
		var target_x = focus_positions[current_focus]
		if not is_equal_approx(position.x, target_x):
			position.x = lerp(position.x, target_x, 5 * delta)


func change_focus(new_focus: String) -> void:
	var previous_focus = current_focus
	current_focus = new_focus
	
	match(current_focus):
		"main_menu":
			match (previous_focus):
				"settings":
					settings_button.grab_focus()
				"credits":
					credits_button.grab_focus()
		"settings":
			settings_section.resolve_proper_focus()
		"credits":
			back_button.grab_focus()
