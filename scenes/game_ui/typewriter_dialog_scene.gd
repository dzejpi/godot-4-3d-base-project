extends Node2D


@onready var text_label: Label = $TextNode/TextBackgroundSprite/TextLabel
@onready var tooltip_label: Label = $TextNode/TextBackgroundSprite/TooltipLabel

# Whether the dialog should stay or not
@export var is_dialog_auto_dismissed: bool = true

var dialog_text: Array[String] = []
var is_dialog_displayed: bool = false

# How many seconds it takes for a new letter to appear
const LETTER_TIMEOUT_BASE_TIME: float = 0.02
var letter_timeout_current: float = LETTER_TIMEOUT_BASE_TIME

var dialog_switch_timeout_current: float = 0.0

# Which line out of all lines is displayed
var currently_displayed_dialog_index: int = 0

# Which letter from the current line is displayed
var currently_displayed_letter: int = 0

# Tooltip variables
var flashing_speed: float = 1
var is_flashing_up: bool = true


func _ready() -> void:
	visible = false
	is_dialog_displayed = false


func _process(delta: float) -> void:
	if is_dialog_displayed:
		process_dialog(delta)
		manage_blinking(delta)
	elif visible:
		visible = false


func start_dialog(dialog_array: Array[String], tooltip_text: String = "") -> void:
	dialog_text = dialog_array
	tooltip_label.text = tooltip_text
	
	visible = true
	is_dialog_displayed = true
	
	currently_displayed_dialog_index = 0
	currently_displayed_letter = 0


func process_dialog(delta: float) -> void:
	var letters_in_current_dialog: int = dialog_text[currently_displayed_dialog_index].length()
	var dialogs_in_array: int = dialog_text.size() - 1
	
	# Player wants to display the whole dialog at once
	if Input.is_action_just_pressed("dialog_forward"):
		# Show all letters at once
		if currently_displayed_letter < letters_in_current_dialog:
			currently_displayed_letter = letters_in_current_dialog
			# Reset the dialog switch timeout. Shorter texts need slightly more time for increased readibility
			adjust_dialog_switch_timeout(letters_in_current_dialog)
		else:
			# All letters are displayed, move to the next dialog
			currently_displayed_dialog_index += 1
			# Start displaying letters from the beginning
			currently_displayed_letter = 0
			# Hide the dialog in case there are no dialogs left
			if currently_displayed_dialog_index > dialogs_in_array:
				is_dialog_displayed = false
				return
	
	# Automatic countdown
	if letter_timeout_current > 0:
		letter_timeout_current -= delta
	else:
		# Add extra letter
		if currently_displayed_letter < letters_in_current_dialog:
			currently_displayed_letter += 1
			
			# If message displayed fully, start with the dialog switch timeout
			if currently_displayed_letter == letters_in_current_dialog and is_dialog_auto_dismissed:
				adjust_dialog_switch_timeout(letters_in_current_dialog)
			else:
				# Reset timeout for the letter
				letter_timeout_current = LETTER_TIMEOUT_BASE_TIME
		
		if currently_displayed_letter == letters_in_current_dialog:
			# Only count down if dialog is set to disappear automatically
			if is_dialog_auto_dismissed:
				if dialog_switch_timeout_current > 0:
					dialog_switch_timeout_current -= delta
					print("Dialog current timeout is: " + str(dialog_switch_timeout_current))
				else:
					currently_displayed_dialog_index += 1
					currently_displayed_letter = 0
					if currently_displayed_dialog_index > dialogs_in_array:
						is_dialog_displayed = false
						return
					
					# Switch timeout ran out, start dialog countdown
					adjust_dialog_switch_timeout(letters_in_current_dialog)
	
	# Display the text, if possible
	if currently_displayed_dialog_index <= dialogs_in_array:
		text_label.text = dialog_text[currently_displayed_dialog_index].left(currently_displayed_letter)
	else:
		is_dialog_displayed = false


func adjust_dialog_switch_timeout(letters_on_line: int) -> void:
	if letters_on_line <= 30:
		dialog_switch_timeout_current = (letters_on_line / 4.0)
	else:
		dialog_switch_timeout_current = (letters_on_line / 8.0)
		
	#print("Dialog switch timeout is: " + str(dialog_switch_timeout_current))


func manage_blinking(delta: float) -> void:
	# Skip if tooltip is empty
	if tooltip_label.text.is_empty():
		return
	
	var current_modulation: float = tooltip_label.modulate.a
	if is_flashing_up:
		if current_modulation < 1.0:
			tooltip_label.modulate.a = min(tooltip_label.modulate.a + (flashing_speed * delta), 1.0)
		else:
			tooltip_label.modulate.a = 1.0
			is_flashing_up = false
	else:
		if current_modulation > 0.0:
			tooltip_label.modulate.a = max(tooltip_label.modulate.a - (flashing_speed * delta), 0.0)
		else:
			tooltip_label.modulate.a = 0.0
			is_flashing_up = true
