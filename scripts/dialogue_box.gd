extends CanvasLayer

signal dialogue_finished

@onready var name_label =$DialoguePanel/NameLabel

@onready var dialogue_text =$DialoguePanel/DialogueText

@onready var continue_text =$DialoguePanel/ContinueText

@onready var type_sfx: AudioStreamPlayer = $DialoguePanel/TypeSFX

const TYPE_SFX_INTERVAL_MS := 45
const TYPE_SFX_PITCH_MIN := 0.95
const TYPE_SFX_PITCH_MAX := 1.05

var pages = []
var current_page = 0

var typing = false
var full_text = ""
var typing_token = 0

var _last_type_sfx_ms := 0

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
		_play_type_sfx(letter)

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

func _play_type_sfx(letter: String) -> void:
	if type_sfx == null:
		return

	if letter == " " or letter == "\n" or letter == "\t":
		return

	var now_ms := Time.get_ticks_msec()
	if now_ms - _last_type_sfx_ms < TYPE_SFX_INTERVAL_MS:
		return

	_last_type_sfx_ms = now_ms
	if TYPE_SFX_PITCH_MIN != TYPE_SFX_PITCH_MAX:
		type_sfx.pitch_scale = randf_range(TYPE_SFX_PITCH_MIN, TYPE_SFX_PITCH_MAX)
	else:
		type_sfx.pitch_scale = 1.0

	type_sfx.play()

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