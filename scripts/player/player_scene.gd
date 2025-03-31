extends CharacterBody3D


const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

@onready var player_camera: Camera3D = $PlayerHead/Camera
@onready var ray_cast: RayCast3D = $PlayerHead/Camera/RayCast3D

# UI parts
@onready var typewriter_dialog: Node2D = $PlayerUI/GameUI/TypewriterDialogScene
@onready var player_tooltip: Node2D = $PlayerUI/GameUI/PlayerTooltip

@onready var game_over_scene: Node2D = $PlayerUI/GameEnd/GameOverScene
@onready var game_won_scene: Node2D = $PlayerUI/GameEnd/GameWonScene

@export var is_fov_dynamic: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity: float = 0.75

# Fov variables
var base_fov: float = 90.0
var increased_fov: float = 94.0
var current_fov: float = base_fov
var fov_change_speed: float = 5.0

# Debug for console info
var debug: bool = true

# Last collider player looked at
var last_looked_at: String = ""


func _ready() -> void:
	GlobalVar.reset_game()
	player_camera.fov = current_fov
	TransitionOverlay.fade_out()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if GlobalVar.is_game_active:
		if event is InputEventMouseMotion:
			rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10
			player_camera.rotation_degrees.x = clamp(player_camera.rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90)


func _physics_process(delta: float) -> void:
	# Not processing at all if the game isn't active
	if not GlobalVar.is_game_active:
		return
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = 0
	velocity.z = 0
	
	var speed_multiplier: float = 1.0
	if Input.is_action_pressed("move_sprint"): 
		speed_multiplier = 2.0
	
	velocity.x = direction.x * SPEED * speed_multiplier
	velocity.z = direction.z * SPEED * speed_multiplier
	
	if is_fov_dynamic:
		if speed_multiplier > 1.0:
			increase_fov(delta)
		else:
			decrease_fov(delta)
	
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


func increase_fov(delta: float) -> void:
	current_fov = player_camera.fov
	current_fov = min(current_fov + fov_change_speed * delta, increased_fov)
	change_fov(current_fov)


func decrease_fov(delta: float) -> void:
	current_fov = player_camera.fov
	current_fov = max(current_fov - fov_change_speed * delta * 8, base_fov)
	change_fov(current_fov)


func change_fov(new_fov: float) -> void:
	player_camera.fov = new_fov
