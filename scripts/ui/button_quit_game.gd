extends TextureButton


var is_button_pressed = false
var platform = OS.get_name()


func _ready():
	if platform == "Web":
		self.disabled = true


func _process(_delta):
	if is_button_pressed:
		if transition_overlay.transition_completed:
			release_focus()
			get_tree().quit()


func _on_pressed():
	is_button_pressed = true
	transition_overlay.fade_in()
