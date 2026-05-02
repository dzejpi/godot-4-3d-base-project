extends TextureButton


@onready var fov_label: Label = $FovLabel
var current_fov: float


func _ready() -> void:
	update_fov_label()


func _on_pressed() -> void:
	current_fov = GlobalVar.player_fov
	
	if current_fov >= 120.0:
		current_fov = 65.0
	else:
		current_fov += 5.0
	
	GlobalVar.player_fov = current_fov
	update_fov_label()


func _on_mouse_entered() -> void:
	grab_focus()


func update_fov_label() -> void:
	fov_label.text = "FOV: " + str(GlobalVar.player_fov)
