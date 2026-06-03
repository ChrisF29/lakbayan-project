extends Control

@onready var title = $ShopTitle
@onready var items_label = $ItemsLabel

var scroll_speed := 5.0
var full_text := "BARTER"
var barter_items := [
	"Palay",
	"Isda",
	"Perlas",
	"Ginto",
	"Kahoy"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure UI is visible
	title.visible = true
	title.modulate.a = 1.0

	# Run letter reveal
	await _reveal_letters()

	# Apply wave AFTER reveal
	_apply_wave()

	_set_items_text()

func _reveal_letters():
	title.bbcode_enabled = false
	title.text = ""

	for i in range(full_text.length() + 1):
		title.text = full_text.substr(0, i)
		await get_tree().create_timer(0.12).timeout

func _apply_wave():
	title.bbcode_enabled = true
	title.text = "[center][wave amp=20 freq=3]" + full_text + "[/wave][/center]"

func _set_items_text():
	if items_label == null:
		return

	var lines = []
	lines.append("[center]Mga puwedeng ipagpalit:")
	for item in barter_items:
		lines.append("- " + item)
	lines.append("[/center]")

	items_label.bbcode_enabled = true
	items_label.text = "\n".join(lines)


func _on_back_pressed() -> void:
	SpawnManager.next_spawn = "MangangalakalNPC"
	get_tree().change_scene_to_file("res://maps/pre_colonial_main_map.tscn")
