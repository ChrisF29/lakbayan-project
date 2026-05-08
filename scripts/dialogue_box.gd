extends CanvasLayer

signal dialogue_finished

@onready var name_label =$DialoguePanel/NameLabel

@onready var dialogue_text =$DialoguePanel/DialogueText

@onready var continue_text =$DialoguePanel/ContinueText

var pages = []
var current_page = 0

var typing = false
var full_text = ""

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

    type_text()

func type_text():

    for letter in full_text:

        dialogue_text.text += letter

        await get_tree().create_timer(0.02).timeout

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

        continue_text.visible = true

        return

    next_page()