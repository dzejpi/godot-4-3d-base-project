extends CharacterBody3D


const ACCELERATION: float = 10.0
const MAX_SPEED: float = 180.0
const MAX_REVERSE_SPEED: float = -20
const TURN_SPEED: float = 60.0
const JUMP_VELOCITY: float = 4.5
const BREAKING_SPEED: float = 20.0
const GRAVITY_MULTIPLIER: float = 10

@onready var player_camera: Camera3D = $PlayerHead/Camera
@onready var ray_cast: RayCast3D = $PlayerHead/Camera/RayCast3D

# UI parts
@onready var typewriter_dialog: Node2D = $PlayerUI/GameUI/TypewriterDialogScene
@onready var player_tooltip: Node2D = $PlayerUI/GameUI/PlayerTooltip

@onready var game_over_scene: Node2D = $PlayerUI/GameEnd/GameOverScene
@onready var game_won_scene: Node2D = $PlayerUI/GameEnd/GameWonScene

@onready var speed_label: Label = $PlayerUI/GameUI/SpeedLabel

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity: float = 0.75
# Mouse movement
var mouse_delta: Vector2 = Vector2.ZERO

var current_speed: float = 0.0

# Debug for console info
var debug: bool = true

# Last collider player looked at
var last_looked_at: String = ""


func _ready() -> void:
	GlobalVar.reset_game()
	TransitionOverlay.fade_out()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if GlobalVar.is_game_active:
		if event is InputEventMouseMotion:
			mouse_delta = event.relative


func _physics_process(delta: float) -> void:
	# Not processing at all if the game isn't active
	if not GlobalVar.is_game_active:
		return
	
	# Camera movement
	adjust_camera()
	
	# Acceleration and braking
	if Input.is_action_pressed("move_up"):
		current_speed = clamp(current_speed + ACCELERATION * delta, MAX_REVERSE_SPEED, MAX_SPEED)
	elif Input.is_action_pressed("move_down"):
		current_speed = clamp(current_speed - ACCELERATION * delta / 2, MAX_REVERSE_SPEED, MAX_SPEED)
	else:
		# Smooth slowdown
		current_speed = move_toward(current_speed, 0, BREAKING_SPEED * delta)
	
	var forward_direction = -transform.basis.z.normalized()
	velocity = forward_direction * current_speed
	
	# Steering
	if Input.is_action_pressed("move_left"):
		if current_speed > 0:
			rotation_degrees.y += TURN_SPEED * delta
		elif current_speed < 0:
			rotation_degrees.y -= TURN_SPEED * delta
	elif Input.is_action_pressed("move_right"):
		if current_speed > 0:
			rotation_degrees.y -= TURN_SPEED * delta
		elif current_speed < 0:
			rotation_degrees.y += TURN_SPEED * delta
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * GRAVITY_MULTIPLIER * delta
	else:
		velocity.y = 0
	
	set_velocity(velocity)
	move_and_slide()
	process_collisions()


func adjust_camera() -> void:
	rotation_degrees.y -= mouse_delta.x * mouse_sensitivity / 10
	player_camera.rotation_degrees.x = clamp(player_camera.rotation_degrees.x - mouse_delta.y * mouse_sensitivity / 10, -90, 90)
	
	# Reset mouse delta
	mouse_delta = Vector2.ZERO


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
