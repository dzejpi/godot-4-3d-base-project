extends Node2D

# Dynamic array of logos
@onready var logo_sprites: Array[Sprite2D] = [
	$Logos/DevLogoSprite,
	$Logos/JamLogoSprite,
]

# Default screen size, adjusted dynamically later
var screen_size: Vector2 = Vector2(1280, 720)

# Which logo is displayed
var current_logo_index: int = 0

var logo_fade_speed: float = 1.0
var logo_display_time: float = 1.0

var logo_timer: float = 0.0
var is_fading_in: bool = true
var is_splash_complete: bool = false

# Startup delay
var startup_delay: float = 0.0
var startup_delay_duration: float = 0.5

# Skip this scene (for debug purposes)
var skip_splash: bool = false


func _ready() -> void:
	TransitionOverlay.fade_out()
	
	# Center logos and set initial transparency
	for logo in logo_sprites:
		logo.position = screen_size / 2
		logo.modulate.a = 0.0
		
	if skip_splash:
		is_splash_complete = true
		go_to_main_menu()
		
	# Connect resizing event
	get_viewport().size_changed.connect(update_screen_size)


func update_screen_size() -> void:
	screen_size = get_viewport().size
	for logo in logo_sprites:
		logo.position = screen_size / 2


func _process(delta: float) -> void:
	if is_splash_complete:
		return
	
	if startup_delay < startup_delay_duration:
		startup_delay += delta
		return
	
	process_logo_fade(delta)


func process_logo_fade(delta: float) -> void:
	var logo: Sprite2D = logo_sprites[current_logo_index]
	if is_fading_in:
		logo.modulate.a = min(logo.modulate.a + (logo_fade_speed * delta), 1.0)
		if logo.modulate.a >= 1.0:
			logo_timer += delta
			if logo_timer >= logo_display_time:
				is_fading_in = false
				logo_timer = 0.0
	else:
		logo.modulate.a = max(logo.modulate.a - (logo_fade_speed * delta), 0.0)
		if logo.modulate.a <= 0.0:
			current_logo_index += 1
			is_fading_in = true
			logo_timer = 0.0
			
			if current_logo_index >= logo_sprites.size():
				is_splash_complete = true
				go_to_main_menu()


func go_to_main_menu() -> void:
	TransitionOverlay.fade_in()
	
	# Wait until is_transition_completed turns to true
	while not TransitionOverlay.is_transition_completed:
		await get_tree().process_frame
	
	get_tree().change_scene_to_file("res://scenes/ui/main_menu_scene.tscn")
