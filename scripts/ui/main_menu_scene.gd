extends Node2D


var current_focus: String = "main_menu"

var focus_positions: Dictionary = {
	"main_menu": 0.0,
	"credits": -1280.0
}


func _ready() -> void:
	TransitionOverlay.fade_out()


func _process(delta: float) -> void:
	if current_focus in focus_positions:
		var target_x = focus_positions[current_focus]
		if not is_equal_approx(position.x, target_x):
			position.x = lerp(position.x, target_x, 5 * delta)


func change_focus(new_focus: String) -> void:
	current_focus = new_focus
