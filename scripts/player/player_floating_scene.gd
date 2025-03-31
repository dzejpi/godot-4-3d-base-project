extends CharacterBody3D


const SPEED: float = 5.0
const FLOAT_VELOCITY: float = 50

@onready var player_camera: Camera3D = $PlayerHead/Camera
@onready var ray_cast: RayCast3D = $PlayerHead/Camera/RayCast3D

# UI parts
@onready var typewriter_dialog: Node2D = $PlayerUI/GameUI/TypewriterDialogScene
@onready var player_tooltip: Node2D = $PlayerUI/GameUI/PlayerTooltip

@onready var game_over_scene: Node2D = $PlayerUI/GameEnd/GameOverScene
@onready var game_won_scene: Node2D = $PlayerUI/GameEnd/GameWonScene


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity: float = 0.75
# Mouse movement
var mouse_delta: Vector2 = Vector2.ZERO

# Constant gravitational pull downwards
var is_pulled_down: bool = false

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
	
	# Vertical movement
	var vertical_velocity: float = 0.0
	if Input.is_action_pressed("move_jump"):
		vertical_velocity += FLOAT_VELOCITY * delta
	elif Input.is_action_pressed("move_crouch"):
		vertical_velocity -= FLOAT_VELOCITY * delta
	
	# Nonstop pull downwards (underwater)
	if is_pulled_down:
		vertical_velocity -= (gravity / 4) * delta
	
	# Smoothly reduce if no input
	velocity.y = lerp(velocity.y, vertical_velocity, 0.1)
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Sprinting
	var speed_multiplier: float = 1.0
	if Input.is_action_pressed("move_sprint"):
		speed_multiplier = 2.0
	
	# Final horizontal velocity
	velocity.x = move_toward(velocity.x, direction.x * SPEED * speed_multiplier, SPEED * delta)
	velocity.z = move_toward(velocity.z, direction.z * SPEED * speed_multiplier, SPEED * delta)
	
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
