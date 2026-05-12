extends Control

@onready var rope_bar =$RopeProgressBar

@onready var dialogue_box =$DialogueBox

@onready var pull_button =$PullButton

@onready var timer =$Timer

@onready var timer_label =$TimerLabel

var rope_value = 50

var enemy_force = 10

var player_force = 5

var game_finished = false

var game_started = false

func _ready():

	rope_bar.value = rope_value

	start_tutorial()

func start_tutorial():

	pull_button.disabled = true

	var dialogue = [

"""
Hilaan Lubid!
""",

"""
Pindutin ang PULL button para hilahin ang lubid.
""",

"""
Kapag umabot sa kanan ang lubid,
ikaw ang mananalo.
"""
	]

	dialogue_box.start(
		"TUTORIAL",
		dialogue
	)

	await dialogue_box.dialogue_finished

	pull_button.disabled = false

	game_started = true

	timer.start()

func _process(delta):

	if game_finished or !game_started:
		return

	rope_value -= enemy_force * delta

	rope_value = clamp(
		rope_value,
		0,
		100
	)

	rope_bar.value = rope_value

	timer_label.text = str(
		int(timer.time_left)
	)

	check_game_result()

func _on_pull_button_pressed():

	if game_finished:
		return

	rope_value += player_force

func check_game_result():

	if rope_value >= 100:

		win_game()

	elif rope_value <= 0:

		lose_game()

func win_game():

	game_finished = true

	print("PLAYER WON")

	QuestManager.set_state(
		"rope_game_complete",
		true
	)

	await get_tree().create_timer(
		1.0
	).timeout

	get_tree().change_scene_to_file(
        "res://quiz/maharlika_quiz.tscn"
	)

func lose_game():

	game_finished = true

	print("PLAYER LOST")

	await get_tree().create_timer(
		1.0
	).timeout

	get_tree().reload_current_scene()

func _on_timer_timeout():

	if game_finished:
		return

	lose_game()
