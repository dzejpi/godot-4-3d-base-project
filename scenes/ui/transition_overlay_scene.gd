extends Node2D


@onready var transition_overlay_sprite: Sprite2D = $TransitionOverlaySprite

var transition_speed: float = 1
var is_transitioning: bool = false
var is_transition_completed: bool = false


func _ready() -> void:
	transition_overlay_sprite.modulate.a = 1.0
	update_overlay_size()
	get_viewport().size_changed.connect(update_overlay_size)
	# Start game with fade out effect 
	fade_out()


func update_overlay_size() -> void:
	transition_overlay_sprite.scale = get_viewport().size


func fade_in() -> void:
	if is_transitioning:
		return
	
	is_transitioning = true
	is_transition_completed = false
	
	# Animate with tween
	var tween := create_tween()
	# Fading in, transition from current alpha to 1.0
	tween.tween_property(transition_overlay_sprite, "modulate:a", 1.0, transition_speed).set_trans(Tween.TRANS_SINE)
	# Run function once finished
	tween.finished.connect(_on_transition_finished)


func fade_out() -> void:
	if is_transitioning:
		return
	
	is_transitioning = true
	is_transition_completed = false
	
	# Animate with tween
	var tween := create_tween()
	# Fading out, transition from current alpha to 0.0
	tween.tween_property(transition_overlay_sprite, "modulate:a", 0.0, transition_speed).set_trans(Tween.TRANS_SINE)
	# Run function once finished
	tween.finished.connect(_on_transition_finished)


func _on_transition_finished() -> void:
	is_transitioning = false
	is_transition_completed = true
