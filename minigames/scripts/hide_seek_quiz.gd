extends Control

@onready var answer_a = $Panel/VBoxContainer/AnswerA

@onready var answer_b = $Panel/VBoxContainer/AnswerB

@onready var answer_c = $Panel/VBoxContainer/AnswerC

@onready var reward_bg = $RewardBG
@onready var reward_label = $RewardBG/RewardLabel

const WRONG_COLOR = Color(1, 0, 0)
const CORRECT_COLOR = Color(0, 1, 0)

func _ready():
	reset_answer_colors()

	answer_a.button_down.connect(
		Callable(self, "preview_answer").bind(answer_a, WRONG_COLOR)
	)

	answer_b.button_down.connect(
		Callable(self, "preview_answer").bind(answer_b, CORRECT_COLOR)
	)

	answer_c.button_down.connect(
		Callable(self, "preview_answer").bind(answer_c, WRONG_COLOR)
	)

	answer_a.pressed.connect(
		Callable(self, "wrong_answer").bind(answer_a)
	)

	answer_b.pressed.connect(
		Callable(self, "correct_answer").bind(answer_b)
	)

	answer_c.pressed.connect(
		Callable(self, "wrong_answer").bind(answer_c)
	)

func wrong_answer(button):
	preview_answer(button, WRONG_COLOR)

	print("WRONG ANSWER")

	await get_tree().create_timer(
		3.0
	).timeout

	get_tree().change_scene_to_file(
        "res://minigames/hide_seek_area.tscn"
	)

func correct_answer(button):
	preview_answer(button, CORRECT_COLOR)

	print("CORRECT!")

	QuestManager.set_state(
		"hide_seek_quiz_complete",
		true
	)

	reward_player()

func preview_answer(button, color):
	reset_answer_colors()
	set_answer_color(button, color)

func set_answer_color(button, color):
	button.add_theme_color_override("font_color", color)
	button.add_theme_color_override("font_color_hover", color)
	button.add_theme_color_override("font_color_pressed", color)
	button.add_theme_color_override("font_color_focus", color)

func reset_answer_colors():
	var buttons = [answer_a, answer_b, answer_c]
	for button in buttons:
		button.remove_theme_color_override("font_color")
		button.remove_theme_color_override("font_color_hover")
		button.remove_theme_color_override("font_color_pressed")
		button.remove_theme_color_override("font_color_focus")

func reward_player():

	PlayerData.ginto += 1
	reward_bg.visible = true
	reward_label.visible = true

	QuestManager.set_quest(
		{
			"text":
			"Bumalik sa DATU o MAGINOO.",

			"target":
			null
		}
	)

	await get_tree().create_timer(
		2.0
	).timeout

	get_tree().change_scene_to_file(
        "res://maps/pre_colonial_main_map.tscn"
	)
