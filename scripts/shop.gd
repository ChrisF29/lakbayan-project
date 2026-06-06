extends Control

@onready var title = $ShopTitle

var scroll_speed := 5.0
var full_text := "BARTER"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure UI is visible
	title.visible = true
	title.modulate.a = 1.0

	# Run letter reveal
	await _reveal_letters()

	# Apply wave AFTER reveal
	_apply_wave()

func _reveal_letters():
	title.bbcode_enabled = false
	title.text = ""

	for i in range(full_text.length() + 1):
		title.text = full_text.substr(0, i)
		await get_tree().create_timer(0.12).timeout

func _apply_wave():
	title.bbcode_enabled = true
	title.text = "[center][wave amp=20 freq=3]" + full_text + "[/wave][/center]"

func _on_back_pressed() -> void:
	if QuestManager.get_state(
		"babaylan_help_barter_pending"
	) \
	and !QuestManager.get_state(
		"babaylan_help_barter_done"
	):
		QuestManager.set_state(
			"babaylan_help_barter_pending",
			false
		)

		QuestManager.set_state(
			"babaylan_help_barter_done",
			true
		)

		QuestManager.complete_quest(
			"Pumunta sa MANGANGALAKAL para sa anito."
		)

		QuestManager.set_quest(
			{
				"text":
				"Bumalik kay BABAYLAN.",

				"target":
				null
			}
		)

	SpawnManager.next_spawn = "MangangalakalNPC"
	get_tree().change_scene_to_file("res://maps/pre_colonial_main_map.tscn")

func _on_buy_kampilan_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shopkampilan.tscn")

func _on_buy_bangkaw_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shopbangkaw.tscn")

func _on_buy_anito_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shopanito.tscn")
