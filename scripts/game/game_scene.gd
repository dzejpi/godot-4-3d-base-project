extends Node3D


@export var debug: bool = false
@export var child_count_countdown: float = 1
var current_child_count_countdown: float = child_count_countdown


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if debug:
		if current_child_count_countdown > 0:
			current_child_count_countdown -= delta
		else:
			current_child_count_countdown = child_count_countdown
			print("Game nodes: " + str(get_child_count()))
