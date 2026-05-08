extends CanvasLayer

signal dialogue_finished

@onready var name_label =$DialoguePanel/NameLabel

@onready var dialogue_text =$DialoguePanel/DialogueText

@onready var continue_text =$DialoguePanel/ContinueText

var pages = []
var current_page = 0

var typing = false
var full_text = ""
var typing_token = 0

func _ready():

	visible = false

func start(speaker_name, dialogue_pages):

	name_label.text = speaker_name

	pages = dialogue_pages

	current_page = 0

	visible = true

	show_page()

func show_page():

	full_text = pages[current_page]

	dialogue_text.text = ""

	continue_text.visible = false

	typing = true

	typing_token += 1
	type_text(typing_token)

func type_text(token):

	for letter in full_text:

		if token != typing_token or !typing:
			return

		dialogue_text.text += letter

		await get_tree().create_timer(0.02).timeout

	if token != typing_token:
		return

	typing = false

	continue_text.visible = true

func next_page():

	current_page += 1

	if current_page >= pages.size():

		visible = false

		dialogue_finished.emit()

		return

	show_page()

func _input(event):

	if !visible:
		return

	if !event.is_pressed():
		return

	if typing:

		dialogue_text.text = full_text

		typing = false

		typing_token += 1

		continue_text.visible = true

		return

	next_page()