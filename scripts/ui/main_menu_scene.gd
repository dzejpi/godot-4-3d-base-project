extends Node2D


var current_focus: String = "main_menu"
@onready var new_game_button: TextureButton = $MainMenuSection/MenuButtons/NewGameButton
@onready var credits_button: TextureButton = $MainMenuSection/MenuButtons/CreditsButton
@onready var back_button: TextureButton = $CreditsSection/BackButton/BackButton


var focus_positions: Dictionary = {
	"main_menu": 0.0,
	"credits": -1280.0
}


func _ready() -> void:
	TransitionOverlay.fade_out()
	new_game_button.grab_focus()


func _process(delta: float) -> void:
	if current_focus in focus_positions:
		var target_x = focus_positions[current_focus]
		if not is_equal_approx(position.x, target_x):
			position.x = lerp(position.x, target_x, 5 * delta)
			print("Current focus: " + current_focus)


func change_focus(new_focus: String) -> void:
	current_focus = new_focus
	
	match(current_focus):
		"main_menu":
			credits_button.grab_focus()
		"credits":
			back_button.grab_focus()
