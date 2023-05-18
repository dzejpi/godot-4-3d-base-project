extends Node2D

var time_out = 0
var time_out_speed = 2
var is_fading_out = true
@onready var transition_overlay_sprite = $TransitionOverlaySprite


func _ready():
	if is_fading_out:
		transition_overlay_sprite.modulate.a = 1
		
	transition_overlay_sprite.scale.x = get_window().size.x
	transition_overlay_sprite.scale.y = get_window().size.y


func _process(delta):
	# Redraw if player changed the window width
	if transition_overlay_sprite.scale.x != get_window().size.x:
		transition_overlay_sprite.scale.x =  get_window().size.x
		transition_overlay_sprite.scale.y = get_window().size.y
	
	# Redraw if player changed the window height
	if transition_overlay_sprite.scale.y != get_window().size.y:
		transition_overlay_sprite.scale.x =  get_window().size.x
		transition_overlay_sprite.scale.y = get_window().size.y
	
	if is_fading_out:
		if time_out < 1:
			time_out += (time_out_speed * delta)
			transition_overlay_sprite.modulate.a = 1 - time_out
	else:
		if time_out < 1:
			time_out += (time_out_speed * delta)
			transition_overlay_sprite.modulate.a = time_out
