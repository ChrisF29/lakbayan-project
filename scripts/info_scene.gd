extends CanvasLayer

signal sequence_finished
signal page_changed(page_index: int, page_text: String)

@export var pages: Array[String] = []
@export var start_on_ready = true
@export var next_scene = ""
@export var typing_delay = 0.03
@export var allow_input = true
@export var fade_in_anim = "fade_in"
@export var fade_out_anim = "fade_out"

@onready var dialogue = $DialogueText
@onready var anim = $AnimationPlayer
@onready var continue_text = $ContinueText

var current_page = 0
var typing = false
var full_text = ""
var typing_token = 0

func _ready():

	if start_on_ready and pages.size() > 0:
		start(pages)

func start(new_pages: Array[String]):

	pages = new_pages
	current_page = 0

	if anim and anim.has_animation(fade_in_anim):
		anim.play(fade_in_anim)

	show_page()

func show_page():

	typing_token += 1

	full_text = pages[current_page]

	dialogue.text = ""

	typing = true

	if continue_text:
		continue_text.visible = false

	page_changed.emit(current_page, full_text)

	type_text(typing_token)

func type_text(token):

	for letter in full_text:

		if token != typing_token or !typing:
			return

		dialogue.text += letter

		await get_tree().create_timer(typing_delay).timeout

	if token != typing_token:
		return

	typing = false

	if continue_text:
		continue_text.visible = true

func _input(event):

	if !allow_input or pages.is_empty():
		return

	if event is InputEventKey:

		if !event.pressed or event.echo:
			return

	elif event is InputEventMouseButton:

		if !event.pressed:
			return

	elif event is InputEventScreenTouch:

		if !event.pressed:
			return

	else:
		return

	if typing:

		typing_token += 1

		dialogue.text = full_text

		typing = false

		if continue_text:
			continue_text.visible = true

		return

	next_page()

func next_page():

	current_page += 1

	if current_page >= pages.size():
		await finish_sequence()
		return

	show_page()

func finish_sequence():

	if anim and anim.has_animation(fade_out_anim):
		anim.play(fade_out_anim)
		await anim.animation_finished

	sequence_finished.emit()

	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)

func _on_blink_timer_timeout():

	if continue_text and !typing:
		continue_text.visible = !continue_text.visible
