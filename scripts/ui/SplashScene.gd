extends Node2D


@onready var dev_logo_sprite = $Logos/DevLogoSprite
@onready var jam_logo_sprite = $Logos/JamLogoSprite
@onready var transition_overlay = $Overlay/TransitionOverlayScene

var screen_width = 1280.0
var screen_height = 720.0

# Logos displayed
var logos_displayed = 0
var logo_display_speed = 1
var logo_show_off_speed = 1
var logo_show_off_timer = 0
var logo_show_off = false
var logo_displaying = true

var everything_displayed = false

# Startup delay
var startup_delay = true
var startup_delay_timer = 0

# Transition at the end
var transition_time_out = 0

# Skip this scene
var skip_splash = false


func _ready():
	# Set the sprite into the center according to the window size
	dev_logo_sprite.position.x = (screen_width / 2)
	dev_logo_sprite.position.y = (screen_height / 2)
	# Opacity
	dev_logo_sprite.modulate.a = 0
	
	jam_logo_sprite.position.x = (screen_width / 2)
	jam_logo_sprite.position.y = (screen_height / 2)
	# Opacity
	jam_logo_sprite.modulate.a = 0
	
	if skip_splash:
		logos_displayed = 2


func _process(delta):
	
	# Make sure that the logo positions rerender in case user changes the window size on splash
	screen_width = 1280
	screen_height = 720
	
	dev_logo_sprite.position.x = (screen_width / 2)
	dev_logo_sprite.position.y = (screen_height / 2)
	
	jam_logo_sprite.position.x = (screen_width / 2)
	jam_logo_sprite.position.y = (screen_height / 2)
	
	if startup_delay:
		if startup_delay_timer <= (logo_show_off_speed / 1.75):
				startup_delay_timer += (logo_show_off_speed * delta)
		else:
			startup_delay = false
	else:
		match logos_displayed:
			0:
				process_dev_logo(delta)
			1:
				process_jam_logo(delta)
			2:
				go_to_main_menu(delta)


func process_dev_logo(delta):
	if logo_displaying:
		if dev_logo_sprite.modulate.a < 1:
			dev_logo_sprite.modulate.a += (logo_display_speed * delta)
		else:
			if logo_show_off_timer <= logo_show_off_speed:
				logo_show_off_timer += (logo_show_off_speed * delta)
			else:
				logo_show_off_timer = 0
				logo_displaying = false
	else:
		if dev_logo_sprite.modulate.a > 0:
			dev_logo_sprite.modulate.a -= (logo_display_speed * delta)
		else:
			logos_displayed += 1
			logo_displaying = true


func process_jam_logo(delta):
	if logo_displaying:
		if jam_logo_sprite.modulate.a < 1:
			jam_logo_sprite.modulate.a += (logo_display_speed * delta)
		else:
			if logo_show_off_timer <= logo_show_off_speed:
				logo_show_off_timer += (logo_show_off_speed * delta)
			else:
				logo_show_off_timer = 0
				logo_displaying = false
	else:
		if jam_logo_sprite.modulate.a > 0:
			jam_logo_sprite.modulate.a -= (logo_display_speed * delta)
		else:
			logos_displayed += 1
			logo_displaying = true


func go_to_main_menu(_delta):
	if !everything_displayed:
		everything_displayed = true
		transition_overlay.fade_in()
	
	if transition_overlay.transition_completed:
		get_tree().change_scene_to_file("res://scenes/ui/MainMenuScene.tscn")
