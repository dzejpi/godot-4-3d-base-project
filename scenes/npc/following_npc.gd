extends CharacterBody3D


@export var is_looking_at_player: bool = false
# Switch between upright standing NPC or not
@export var is_looking_freely: bool = false
@export var is_following_player: bool = false

@export var move_speed: float = 3.0
@export var acceleration: float = 10.0

const JUMP_VELOCITY: float = 4.5

var player: Node3D = null
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	# Find player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]


func _physics_process(delta: float) -> void:
	# Nothing if no player is present
	if not player:
		return
	
	# Nothing if the game is not active
	if not GlobalVar.is_game_active:
		return
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	if is_looking_at_player:
		if is_looking_freely:
			# Face towards the player completely
			look_at(player.global_transform.origin, Vector3.UP)
		else:
			# Prevent Z rotation to stand upright
			var direction = (player.global_transform.origin - global_transform.origin).normalized()
			direction.y = 0
			look_at(global_transform.origin + direction, Vector3.UP)
	
	if is_following_player:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0
		
		velocity = velocity.lerp(direction * move_speed, acceleration * delta)
	
	move_and_slide()


func jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
