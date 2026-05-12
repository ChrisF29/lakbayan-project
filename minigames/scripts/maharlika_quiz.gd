extends Control

@onready var answer_a = $Panel/VBoxContainer/AnswerA
@onready var answer_b = $Panel/VBoxContainer/AnswerB
@onready var answer_c = $Panel/VBoxContainer/AnswerC
@onready var reward_label = $RewardLabel

func _ready():

	answer_a.pressed.connect(
		Callable(self, "correct_answer")
	)

	answer_b.pressed.connect(
		Callable(self, "wrong_answer")
	)

	answer_c.pressed.connect(
		Callable(self, "wrong_answer")
	)

func wrong_answer():

	get_tree().change_scene_to_file(
		"res://minigames/hilaan_lubid.tscn"
	)

func correct_answer():

	QuestManager.set_state(
		"rope_game_complete",
		true
	)

	reward_player()

func reward_player():

	PlayerData.perlas += 1
	reward_label.visible = true

	QuestManager.set_quest(
		{
			"text":
			"Pumunta sa MAHARLIKA.",

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
