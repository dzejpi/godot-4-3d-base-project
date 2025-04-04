extends CharacterBody3D


const SPEED: float = 10.0
const TURN_SPEED: float = 200.0

@onready var ray_cast: RayCast3D = $PlayerHead/Camera/RayCast3D

# UI parts
@onready var typewriter_dialog: Node2D = $PlayerUI/GameUI/TypewriterDialogScene
@onready var player_tooltip: Node2D = $PlayerUI/GameUI/PlayerTooltip

@onready var game_over_scene: Node2D = $PlayerUI/GameEnd/GameOverScene
@onready var game_won_scene: Node2D = $PlayerUI/GameEnd/GameWonScene

var mouse_sensitivity: float = 0.75
# Mouse movement
var mouse_delta: Vector2 = Vector2.ZERO

# Debug for console info
var debug: bool = true

# Last collider player looked at
var last_looked_at: String = ""


func _ready() -> void:
	GlobalVar.reset_game()
	TransitionOverlay.fade_out()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	# Not processing at all if the game isn't active
	if not GlobalVar.is_game_active:
		return
	
	var forward_direction = -transform.basis.z.normalized()
	velocity = forward_direction * SPEED
	
	var pitch = rotation_degrees.x
	var yaw = rotation_degrees.y
	
	if Input.is_action_pressed("move_up"):
		pitch += TURN_SPEED * delta
	elif Input.is_action_pressed("move_down"):
		pitch -= TURN_SPEED * delta

	if Input.is_action_pressed("move_left"):
		yaw -= TURN_SPEED * delta
	elif Input.is_action_pressed("move_right"):
		yaw += TURN_SPEED * delta
	
	rotation_degrees.x = lerp_angle(rotation_degrees.x, pitch, 0.1)
	rotation_degrees.y = lerp_angle(rotation_degrees.y, yaw, 0.1)
	
	move_and_slide()
	process_collisions()


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
