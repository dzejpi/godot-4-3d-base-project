extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var player_camera = $PlayerHead/Camera
@onready var ray_cast = $PlayerHead/Camera/RayCast3D

# UI parts
@onready var game_pause_scene = $PlayerUI/Pause/GamePauseScene
@onready var game_over_scene = $PlayerUI/GameEnd/GameOverScene
@onready var game_won_scene = $PlayerUI/GameEnd/GameWonScene
@onready var typewriter_dialog = $PlayerUI/GameUI/TypewriterDialogScene
@onready var player_tooltip = $PlayerUI/GameUI/PlayerTooltip

@export var is_fov_dynamic = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity = 0.75

var is_game_paused = false
var is_game_over = false
var is_game_won = false

var base_fov = 90
var increased_fov = 94
var current_fov = base_fov
var fov_change_speed = 5

var debug = false


func _ready():
	player_camera.fov = current_fov
	transition_overlay.fade_out()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	is_game_paused = false
	game_pause_scene.hide()
	game_over_scene.hide()
	game_won_scene.hide()


func _process(_delta):
	process_collisions()
	# Update pause state if the user clicks on Continue
	if is_game_paused:
		listen_for_pause_button_change()


func _input(event):
	if !is_game_paused && !is_game_over && !is_game_won:
		if event is InputEventMouseMotion:
			rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10
			player_camera.rotation_degrees.x = clamp(player_camera.rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90)
	
	if Input.is_action_just_pressed("game_pause"):
		if !is_game_over && !is_game_won:
			if is_game_paused:
				is_game_paused = false
				game_pause_scene.is_game_paused = is_game_paused
			else:
				is_game_paused = true
				game_pause_scene.is_game_paused = is_game_paused
		
		update_pause_state()


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if Input.is_action_pressed("move_sprint"):
			if !is_game_paused && !is_game_over && !is_game_won:
				velocity.x = direction.x * SPEED * 2
				velocity.z = direction.z * SPEED * 2
				if is_fov_dynamic:
					increase_fov(delta)
			else:
				velocity.x = direction.x * 0
				velocity.z = direction.z * 0
				if is_fov_dynamic:
					decrease_fov(delta)
		else:
			if !is_game_paused && !is_game_over && !is_game_won:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				if is_fov_dynamic:
					decrease_fov(delta)
			else:
				velocity.x = direction.x * 0
				velocity.z = direction.z * 0
				if is_fov_dynamic:
					decrease_fov(delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if is_fov_dynamic:
			decrease_fov(delta)
	
	move_and_slide()


func process_collisions():
	if ray_cast.is_colliding():
		var collision_object = ray_cast.get_collider().name
		
		if debug:
			print("Player is looking at: " + collision_object + ".")
	else:
		if debug:
			print("Player is looking at: nothing.")


func update_pause_state():
	if is_game_paused:
		game_pause_scene.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		game_pause_scene.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func listen_for_pause_button_change():
	if !(game_pause_scene.is_game_paused):
		is_game_paused = game_pause_scene.is_game_paused
		update_pause_state()


func toggle_game_over():
	is_game_over = true
	game_over_scene.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func toggle_game_won():
	is_game_won = true
	game_won_scene.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func increase_fov(delta):
	current_fov = player_camera.fov
	if current_fov < increased_fov:
		current_fov += fov_change_speed * delta
		
		if current_fov > increased_fov:
			current_fov = increased_fov
		
		change_fov(current_fov)


func decrease_fov(delta):
	current_fov = player_camera.fov
	
	if current_fov > base_fov:
		current_fov -= fov_change_speed * delta * 8
		
		if current_fov < base_fov:
			current_fov = base_fov
		
		change_fov(current_fov)


func change_fov(new_fov):
	player_camera.fov = new_fov
