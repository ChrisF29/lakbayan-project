extends CanvasLayer

@onready var dialogue = $DialogueText
@onready var anim = $AnimationPlayer
@onready var continue_text = $ContinueText

var typing = false
var full_text = ""
var typing_token = 0
var transitioning = false

var pages = [

"""
Bago dumating ang mga Espanyol,
""",

"""
May sariling sistemang panlipunan
ang mga sinaunang Filipino
na tinatawag na barangay.
""",

"""
Nahahati ang lipunan batay sa
yaman, kapangyarihan,
at pribilehiyo.
""",

"""
May tatlong pangunahing antas,
""",

"""
Una ay ang Datu at Maginoo, o ang mga pinuno at mayayaman,
""",

"""
Sumunod ay ang Maharlika at Timawa, o malalayang tao,
""",

"""
Panghuli ay ang Alipin o Oripun, o ang mga umaasa sa iba.
"""
]

var current_page = 0

func _ready():

	anim.play("fade_in")

	show_page()

func show_page():

	typing_token += 1

	full_text = pages[current_page]

	dialogue.text = ""

	typing = true

	continue_text.visible = false

	type_text(typing_token)

func type_text(token):

	for letter in full_text:

		if token != typing_token:
			return

		dialogue.text += letter

		await get_tree().create_timer(0.03).timeout

	if token != typing_token:
		return

	typing = false

	continue_text.visible = true

func _input(event):
	if transitioning:
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

		continue_text.visible = true

		return

	next_page()

func next_page():

	current_page += 1

	if current_page >= pages.size():

		start_game()

		return

	show_page()

func start_game():
	if transitioning:
		return

	transitioning = true

	anim.play("fade_out")

	await anim.animation_finished

	if !is_inside_tree():
		return

	var tree = get_tree()
	if tree == null:
		return

	tree.change_scene_to_file("res://maps/library_map.tscn")

func _on_blink_timer_timeout():

	if !typing:

		continue_text.visible = !continue_text.visible
