extends Node2D


@onready var tooltip_label = $TooltipLabel

var flashing_speed = 1
var is_flashing = false
var is_flashing_up = true
var is_tooltip_visible = false
var current_alpha = 0
var action_required = ""


func _ready():
	is_tooltip_visible = false
	self.hide()


func _process(delta):
	if is_flashing:
		if is_flashing_up:
			var current_modulation = self.modulate.a
			if current_modulation < 1:
				self.modulate.a += flashing_speed * delta
			else:
				self.modulate.a = 1
				is_flashing_up = false
		else:
			var current_modulation = self.modulate.a
			if current_modulation > 0:
				self.modulate.a -= flashing_speed * delta
			else:
				self.modulate.a = 0
				is_flashing_up = true


func _input(_event):
	# Don't check if the string is empty
	if action_required.length() > 1:
		if Input.is_action_just_pressed(action_required):
			dismiss_tooltip()


func display_tooltip(tooltip_text, tooltip_flashing):
	tooltip_label.text = tooltip_text
	
	if tooltip_flashing:
		self.modulate.a = 0
		is_flashing = true
	else:
		self.modulate.a = 1
		is_flashing = false
	
	is_tooltip_visible = true
	self.show()


func set_tooltip_action(new_action_required):
	action_required = new_action_required


func dismiss_tooltip():
	tooltip_label.text = ""
	action_required = ""
	is_flashing = false
	is_tooltip_visible = false
	self.hide()
