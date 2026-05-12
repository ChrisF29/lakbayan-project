extends Area2D

var player_inside = false

@onready var interact_button = $"../MobileUI/InteractButton"
@onready var fade = $"../FadeLayer"

func _process(delta):

	if player_inside \
	and Input.is_action_just_pressed(
		"interact"
	):
		start_game()

func start_game():

	if !QuestManager.get_state(
		"rope_game_started"
	):
		return

	interact_button.visible = false

	await fade.fade_out()

	get_tree().change_scene_to_file(
		"res://minigames/hilaan_lubid.tscn"
	)

func _on_body_entered(body):

	if body.is_in_group("player"):

		player_inside = true

		if QuestManager.get_state(
			"rope_game_started"
		):
			interact_button.visible = true

func _on_body_exited(body):

	if body.is_in_group("player"):

		player_inside = false

		interact_button.visible = false
