extends CharacterBody3D


const SPEED = 10.0
const TURN_SPEED = 15.0

@onready var ray_cast = $PlayerHead/Camera/RayCast3D

# UI parts
@onready var game_pause_scene = $PlayerUI/Pause/GamePauseScene
@onready var game_over_scene = $PlayerUI/GameEnd/GameOverScene
@onready var game_won_scene = $PlayerUI/GameEnd/GameWonScene
@onready var typewriter_dialog = $PlayerUI/GameUI/TypewriterDialogScene
@onready var player_tooltip = $PlayerUI/GameUI/PlayerTooltip


var mouse_sensitivity = 0.75

var is_game_paused = false
var is_game_over = false
var is_game_won = false

var debug = false


func _ready():
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
