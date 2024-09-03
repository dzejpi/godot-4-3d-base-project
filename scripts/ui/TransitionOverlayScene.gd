extends Node2D


var time_out = 0
@onready var transition_overlay_sprite = $TransitionOverlaySprite

var transition_time_out = 0
var transition_speed = 2
var transition_completed = true
var transition_in = false


func _ready():
	transition_overlay_sprite.modulate.a = 0
	transition_overlay_sprite.scale.x = DisplayServer.window_get_size().x
	transition_overlay_sprite.scale.y = DisplayServer.window_get_size().y


func _process(delta):
	# Seems that redrawing is not necessary
	#if transition_overlay_sprite.scale.x != DisplayServer.window_get_size().x:
	#	transition_overlay_sprite.scale.x = DisplayServer.window_get_size().x
	#if transition_overlay_sprite.scale.y != DisplayServer.window_get_size().y:
	#	transition_overlay_sprite.scale.y = DisplayServer.window_get_size().y
	
	# Handle screen transition
	if !transition_completed:
		if transition_time_out < 1:
			transition_time_out += (transition_speed * delta)
			if transition_in:
				transition_overlay_sprite.modulate.a = transition_time_out
			else:
				transition_overlay_sprite.modulate.a = (1 - transition_time_out)
		else:
			transition_completed = true


func fade_in():
	reset_transition()
	transition_in = true


func fade_out():
	reset_transition()
	transition_in = false


func reset_transition():
	transition_completed = false
	transition_time_out = 0
