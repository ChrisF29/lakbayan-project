extends Control

@onready var title = $GameTitle
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: TextureRect = $Options

var full_text := "LAKBAYAN"

func _enter_tree() -> void:
	if Input.has_method("set_emulate_mouse_from_touch"):
		Input.set_emulate_mouse_from_touch(true)

func _ready():
	main_buttons.visible = true
	options.visible = false
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


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://main_game/main_game.tscn")


func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true

func _on_back_pressed() -> void:
	main_buttons.visible = true
	options.visible = false

func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://shop/shop.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
