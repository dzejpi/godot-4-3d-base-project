extends Node2D


@onready var text_label = $TextNode/TextBackgroundSprite/TextLabel

var dialog_text = ["Placeholder text."]
var is_dialog_displayed = false

# How quickly new letter appears in seconds
var letter_change_speed = 16

# Timeout for the single letters
var letter_timeout_current = 0
var letter_timeout_base_time = 1

# Timeout for another dialog to appear
var dialog_switch_timeout_current = 0
var dialog_switch_timeout_base_time = 1

# Which line out of all lines is displayed
var currently_displayed_dialog_from_array = 0

# Which letter from the current line is displayed
var currently_displayed_letter = 0


func _ready():
	visible = false
	is_dialog_displayed = false


func _process(delta):
	if is_dialog_displayed:
		process_dialog(delta)
	else:
		visible = false
	
	#print("Dialog switch timeout current:" + str(dialog_switch_timeout_current))


func start_dialog(dialog_array, delta):
	dialog_text = dialog_array
	visible = true
	is_dialog_displayed = true
	
	currently_displayed_dialog_from_array = 0
	currently_displayed_letter = 0
	
	process_dialog(delta)


func process_dialog(delta):
	var letters_on_current_line = dialog_text[currently_displayed_dialog_from_array].length()
	var dialogs_in_array = dialog_text.size() - 1;
	
	# If the player wants to display the whole character
	if Input.is_action_just_pressed("dialog_end"):
		# Show all letters at once
		if currently_displayed_letter < letters_on_current_line:
			currently_displayed_letter = letters_on_current_line
			# Reset the dialog switch timeout. Shorter texts need slightly more time for increased readibility
			adjust_dialog_switch_timeout(letters_on_current_line)
		else:
			# All letters are displayed, start showing the next line of the dialog
			currently_displayed_dialog_from_array += 1
			# Start displaying letters from the beginning
			currently_displayed_letter = 0
			# Hide the dialog in case there are no dialogs left
			if currently_displayed_dialog_from_array > dialogs_in_array:
				is_dialog_displayed = false
	
	# Automatic behavior
	if letter_timeout_current > 0:
		letter_timeout_current -= (letter_change_speed * delta)
	else:
		# Reset timeout for the letter
		letter_timeout_current = letter_timeout_base_time
		
		# Add extra letter
		if currently_displayed_letter < letters_on_current_line:
			currently_displayed_letter += 1
			# If message was just displayed fully, start with the dialog switch timeout
			if currently_displayed_letter == letters_on_current_line:
				adjust_dialog_switch_timeout(letters_on_current_line)
		if currently_displayed_letter == letters_on_current_line:
			if dialog_switch_timeout_current > 0:
				dialog_switch_timeout_current -= (letter_change_speed * delta)
			else:
				# Switch timeout ran out, display new dialog
				adjust_dialog_switch_timeout(letters_on_current_line)
				currently_displayed_dialog_from_array += 1
				currently_displayed_letter = 0
				if currently_displayed_dialog_from_array > dialogs_in_array:
					is_dialog_displayed = false
	
	# Display the text, if possible
	if currently_displayed_dialog_from_array > dialogs_in_array:
		is_dialog_displayed = false
	else:
		text_label.text = dialog_text[currently_displayed_dialog_from_array].left(currently_displayed_letter)


func adjust_dialog_switch_timeout(letters_on_line):
	if letters_on_line <= 30:
		dialog_switch_timeout_current = dialog_switch_timeout_base_time + (letters_on_line)
	else:
		dialog_switch_timeout_current = dialog_switch_timeout_base_time + (letters_on_line / 4)
