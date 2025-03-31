extends Node2D


@onready var text_label: Label = $TextNode/TextBackgroundSprite/TextLabel

var dialog_text: Array[String] = ["Placeholder text."]
var is_dialog_displayed: bool = false

# How quickly dialog disappears in seconds
const DIALOG_CHANGE_SPEED: float = 16.0

# Timeout for single letters
const DIALOG_SWITCH_TIMEOUT_BASE_TIME: float = 1.0

# Timeout for another letter to appear
const LETTER_TIMEOUT_BASE_TIME: float = 1.0
var letter_timeout_current: float = LETTER_TIMEOUT_BASE_TIME
var dialog_switch_timeout_current: float = DIALOG_SWITCH_TIMEOUT_BASE_TIME

# Which line out of all lines is displayed
var currently_displayed_dialog_index: int = 0

# Which letter from the current line is displayed
var currently_displayed_letter: int = 0


func _ready() -> void:
	visible = false
	is_dialog_displayed = false


func _process(delta: float) -> void:
	if is_dialog_displayed:
		process_dialog(delta)
	elif visible:
		visible = false


func start_dialog(dialog_array: Array[String], delta: float) -> void:
	dialog_text = dialog_array
	visible = true
	is_dialog_displayed = true
	
	currently_displayed_dialog_index = 0
	currently_displayed_letter = 0


func process_dialog(delta: float) -> void:
	var letters_on_current_line: int = dialog_text[currently_displayed_dialog_index].length()
	var dialogs_in_array: int = dialog_text.size() - 1
	
	# Player wants to display the whole dialog at once
	if Input.is_action_just_pressed("dialog_forward"):
		# Show all letters at once
		if currently_displayed_letter < letters_on_current_line:
			currently_displayed_letter = letters_on_current_line
			# Reset the dialog switch timeout. Shorter texts need slightly more time for increased readibility
			adjust_dialog_switch_timeout(letters_on_current_line)
		else:
			# All letters are displayed, start showing the next line of the dialog
			currently_displayed_dialog_index += 1
			# Start displaying letters from the beginning
			currently_displayed_letter = 0
			# Hide the dialog in case there are no dialogs left
			if currently_displayed_dialog_index > dialogs_in_array:
				is_dialog_displayed = false
				return
	
	# Automatic behavior
	if letter_timeout_current > 0:
		letter_timeout_current -= DIALOG_CHANGE_SPEED * delta
	else:
		# Reset timeout for the letter
		letter_timeout_current = LETTER_TIMEOUT_BASE_TIME
		
		# Add extra letter
		if currently_displayed_letter < letters_on_current_line:
			currently_displayed_letter += 1
			# If message was just displayed fully, start with the dialog switch timeout
			if currently_displayed_letter == letters_on_current_line:
				adjust_dialog_switch_timeout(letters_on_current_line)
		
		if currently_displayed_letter == letters_on_current_line:
			if dialog_switch_timeout_current > 0:
				dialog_switch_timeout_current -= DIALOG_CHANGE_SPEED * delta
			else:
				currently_displayed_dialog_index += 1
				currently_displayed_letter = 0
				if currently_displayed_dialog_index > dialogs_in_array:
					is_dialog_displayed = false
					return
				
				# Switch timeout ran out, display new dialog
				adjust_dialog_switch_timeout(letters_on_current_line)
	
	# Display the text, if possible
	if currently_displayed_dialog_index <= dialogs_in_array:
		text_label.text = dialog_text[currently_displayed_dialog_index].left(currently_displayed_letter)
	else:
		is_dialog_displayed = false


func adjust_dialog_switch_timeout(letters_on_line: int) -> void:
	if letters_on_line <= 30:
		dialog_switch_timeout_current = DIALOG_SWITCH_TIMEOUT_BASE_TIME + letters_on_line
	else:
		dialog_switch_timeout_current = DIALOG_SWITCH_TIMEOUT_BASE_TIME + (letters_on_line / 4.0)
