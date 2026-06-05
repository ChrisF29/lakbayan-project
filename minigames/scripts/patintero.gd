extends Node2D

func _ready():
	print("Player groups:")
	print(get_groups())
func _on_back_pressed() -> void:

	pass

func _on_finish_area_body_entered(body):

	if body.is_in_group("player"):
		win_patintero()

func win_patintero():

	QuestManager.set_state(
		"patintero_complete",
		true
	)

	get_tree().change_scene_to_file(
		"res://quiz/babaylan_quiz.tscn"
	)

func player_caught():

	get_tree().reload_current_scene()
