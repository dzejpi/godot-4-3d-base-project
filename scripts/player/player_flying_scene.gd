extends CharacterBody3D


const SPEED: float = 10.0
const TURN_SPEED: float = 15.0

@onready var ray_cast: RayCast3D = $PlayerHead/Camera/RayCast3D

# UI parts
@onready var typewriter_dialog: Node2D = $PlayerUI/GameUI/TypewriterDialogScene
@onready var player_tooltip: Node2D = $PlayerUI/GameUI/PlayerTooltip

@onready var game_over_scene: Node2D = $PlayerUI/GameEnd/GameOverScene
@onready var game_won_scene: Node2D = $PlayerUI/GameEnd/GameWonScene

var mouse_sensitivity: float = 0.75

# Debug for console info
var debug: bool = true

# Last collider player looked at
var last_looked_at: String = ""


func _ready() -> void:
	GlobalVar.reset_game()
	TransitionOverlay.fade_out()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta: float) -> void:
	process_collisions()


func _physics_process(delta: float) -> void:
	# Not processing at all if the game isn't active
	if not GlobalVar.is_game_active:
		return
	
	var forward_direction = -transform.basis.z.normalized()
	velocity = forward_direction * SPEED
	
	if Input.is_action_pressed("move_up"):
		rotation_degrees.x += TURN_SPEED * delta
	elif Input.is_action_pressed("move_down"):
		rotation_degrees.x -= TURN_SPEED * delta

	if Input.is_action_pressed("move_left"):
		rotation_degrees.y += TURN_SPEED * delta
	elif Input.is_action_pressed("move_right"):
		rotation_degrees.y -= TURN_SPEED * delta
	
	move_and_slide()


func process_collisions() -> void:
	if ray_cast.is_colliding():
		var collision_object: String = ray_cast.get_collider().name
		if collision_object != last_looked_at:
			last_looked_at = collision_object
			if debug:
				print("Player is looking at: " + collision_object + ".")
	else:
		if last_looked_at != "nothing":
			last_looked_at = "nothing"
			if debug:
				print("Player is looking at: nothing.")


func trigger_game_over() -> void:
	GlobalVar.toggle_game_over()
	game_over_scene.show_game_over()


func trigger_game_won() -> void:
	GlobalVar.toggle_game_won()
	game_won_scene.show_game_won()
