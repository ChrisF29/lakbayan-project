extends Control

@onready var progress_bar = $PullBar
@onready var pull_button = $PullButton
@onready var dialogue_box = $DialogueBox
@onready var timer_label = $TimerLabel
@onready var timer = $Timer

var rope_value = 50.0
var time_left = 30
var game_over = false
var game_started = false

func _ready():

	progress_bar.min_value = 0
	progress_bar.max_value = 100
	progress_bar.value = rope_value

	pull_button.pressed.connect(
		Callable(self, "_on_pull_button_pressed")
	)

	timer.timeout.connect(
		Callable(self, "_on_timer_timeout")
	)

	pull_button.disabled = true

	start_tutorial()

func start_tutorial():

	var dialogue = [

"""
Pindutin ang PULL para hilahin ang lubid.
""",

"""
Panatilihin sa kanan ang marka para manalo.
"""
	]

	dialogue_box.start(
		"TUTORIAL",
		dialogue
	)

	await dialogue_box.dialogue_finished

	pull_button.disabled = false
	game_started = true
	update_timer_label()
	timer.start()

func _process(delta):

	if game_over or !game_started:
		return

	rope_value -= delta * 10.0
	rope_value = clamp(rope_value, 0.0, 100.0)

	progress_bar.value = rope_value

	if rope_value >= 100.0:
		win_game()
		return

	if rope_value <= 0.0:
		lose_game()

func _on_pull_button_pressed():

	if game_over or !game_started:
		return

	rope_value += 5.0
	rope_value = clamp(rope_value, 0.0, 100.0)

func _on_timer_timeout():

	if game_over:
		return

	time_left -= 1
	update_timer_label()

	if time_left <= 0:
		lose_game()

func update_timer_label():

	timer_label.text = "TIME: " + str(time_left)

func lose_game():

	if game_over:
		return

	game_over = true
	get_tree().reload_current_scene()

func win_game():

	if game_over:
		return

	game_over = true

	get_tree().change_scene_to_file(
		"res://quiz/maharlika_quiz.tscn"
	)
