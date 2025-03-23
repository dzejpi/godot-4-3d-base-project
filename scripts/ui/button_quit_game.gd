extends TextureButton


@onready var platform: String = OS.get_name()

var is_button_pressed: bool = false


func _ready() -> void:
	if platform == "Web":
		self.disabled = true


func _process(_delta: float) -> void:
	if is_button_pressed and TransitionOverlay.is_transition_completed:
		release_focus()
		get_tree().quit()


func _on_pressed() -> void:
	is_button_pressed = true
	TransitionOverlay.fade_in()
