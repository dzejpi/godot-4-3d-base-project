extends TextureButton


@onready var mouse_sensitivity_label: Label = $MouseSensitivityLabel
var mouse_sensitivity: float


func _ready() -> void:
	update_sensitivity_label()


func _on_pressed() -> void:
	mouse_sensitivity = GlobalVar.mouse_sensitivity
	
	if mouse_sensitivity >= 2.0:
		mouse_sensitivity = 0.25
	else:
		mouse_sensitivity += 0.25
	
	GlobalVar.mouse_sensitivity = mouse_sensitivity
	update_sensitivity_label()


func _on_mouse_entered() -> void:
	grab_focus()


func update_sensitivity_label() -> void:
	mouse_sensitivity_label.text = "Mouse sensitivity: " + str(int(GlobalVar.mouse_sensitivity * 100)) + " %"
