extends Node2D


var current_focus = "main_menu"
var main_menu_x_position = 0.0
var credits_x_position = -1280.0


func _ready():
	pass


func _process(delta):
	match(current_focus):
		"main_menu":
			if position.x != main_menu_x_position:
				position.x = lerp(position.x, main_menu_x_position, 5 * delta)
		"credits":
			if position.x != credits_x_position:
				position.x = lerp(position.x, credits_x_position, 5 * delta)


func change_focus(new_focus):
	if current_focus != new_focus:
		current_focus = new_focus
