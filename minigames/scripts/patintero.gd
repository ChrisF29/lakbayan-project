extends Control

@onready var title = $Title
@onready var hint = $Hint

func _ready():

	if title:
		title.text = "PATINTERO"

	if hint:
		hint.text = "Mini game placeholder"

func _on_back_pressed() -> void:

	QuestManager.set_state(
		"anito_quest_complete",
		true
	)

	QuestManager.set_state(
		"babaylan_help_done",
		true
	)

	QuestManager.complete_quest(
		"Kunin ang Sagradong anito."
	)

	get_tree().change_scene_to_file(
		"res://maps/pre_colonial_main_map.tscn"
	)
