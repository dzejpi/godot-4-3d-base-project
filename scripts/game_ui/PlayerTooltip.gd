extends Node2D


@onready var tooltip_label = $TooltipLabel

var flashing_speed = 1
var is_flashing = false
var is_flashing_up = true
var current_alpha = 0


func _ready():
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


func display_tooltip(tooltip_text, tooltip_flashing):
	tooltip_label.text = tooltip_text
	
	if tooltip_flashing:
		self.modulate.a = 0
		is_flashing = true
	else:
		self.modulate.a = 1
		is_flashing = false
	
	self.show()


func dismiss_tooltip():
	tooltip_label.text = ""
	is_flashing = false
	self.hide()
