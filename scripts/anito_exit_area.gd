extends Area2D

var teleporting = false

@onready var fade = $"../FadeLayer"

func _on_body_entered(body):

	if teleporting:
		return

	if !body.is_in_group("player"):
		return

	if !QuestManager.get_state(
		"anito_quest_started"
	):
		return

	if QuestManager.get_state(
		"anito_quest_complete"
	):
		return

	teleporting = true

	if fade != null:
		await fade.fade_out()

	get_tree().change_scene_to_file(
		"res://quiz/babaylan_quiz.tscn"
	)
