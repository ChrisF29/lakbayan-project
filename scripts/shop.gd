extends Control

@onready var title = $ShopTitle
@onready var buy_kampilan_btn = $Item1/BuyKampilan
@onready var buy_bangkaw_btn = $Item2/BuyBangkaw
@onready var buy_anito_btn = $Item3/BuyAnito

var scroll_speed := 5.0
var full_text := "BARTER"

const PRICE_KAMPILAN := 1 # cost in ginto
const PRICE_BANGKAW := 1  # cost in perlas
const PRICE_ANITO := 1    # cost in ginto

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure UI is visible
	title.visible = true
	title.modulate.a = 1.0

	# Run letter reveal
	await _reveal_letters()

	# Apply wave AFTER reveal
	_apply_wave()

	# Update buy buttons to reflect current currency / ownership
	_update_buy_buttons()

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
	if PlayerData.has_kampilan:
		_open_item_info("res://scenes/shopkampilan.tscn")
		return

	_attempt_purchase_kampilan()

func _on_buy_bangkaw_pressed() -> void:
	if PlayerData.has_bangkaw:
		_open_item_info("res://scenes/shopbangkaw.tscn")
		return

	_attempt_purchase_bangkaw()

func _on_buy_anito_pressed() -> void:
	if PlayerData.has_anito:
		_open_item_info("res://scenes/shopanito.tscn")
		return

	_attempt_purchase_anito()


func _update_buy_buttons() -> void:
	# Disable/label buttons based on ownership and affordability
	if PlayerData.has_kampilan:
		buy_kampilan_btn.disabled = false
		buy_kampilan_btn.text = "Info"
	else:
		buy_kampilan_btn.disabled = PlayerData.ginto < PRICE_KAMPILAN
		buy_kampilan_btn.text = "Buy 1 Gold"

	if PlayerData.has_bangkaw:
		buy_bangkaw_btn.disabled = false
		buy_bangkaw_btn.text = "Info"
	else:
		buy_bangkaw_btn.disabled = PlayerData.perlas < PRICE_BANGKAW
		buy_bangkaw_btn.text = "Buy 1 Perlas"

	if PlayerData.has_anito:
		buy_anito_btn.disabled = false
		buy_anito_btn.text = "Info"
	else:
		buy_anito_btn.disabled = PlayerData.ginto < PRICE_ANITO
		buy_anito_btn.text = "Buy 1 Gold"


func _attempt_purchase_kampilan() -> void:
	if PlayerData.has_kampilan:
		_show_message("You already own Kampilan.")
		return

	if PlayerData.ginto >= PRICE_KAMPILAN:
		PlayerData.ginto -= PRICE_KAMPILAN
		PlayerData.has_kampilan = true
		PlayerData.save_game()
		_update_buy_buttons()
		_show_message("Purchased Kampilan!")
	else:
		_show_message("Not enough Ginto to buy Kampilan.")


func _attempt_purchase_bangkaw() -> void:
	if PlayerData.has_bangkaw:
		_show_message("You already own Bangkaw.")
		return

	if PlayerData.perlas >= PRICE_BANGKAW:
		PlayerData.perlas -= PRICE_BANGKAW
		PlayerData.has_bangkaw = true
		PlayerData.save_game()
		_update_buy_buttons()
		_show_message("Purchased Bangkaw!")
	else:
		_show_message("Not enough Perlas to buy Bangkaw.")


func _attempt_purchase_anito() -> void:
	if PlayerData.has_anito:
		_show_message("You already own Anito.")
		return

	if PlayerData.ginto >= PRICE_ANITO:
		PlayerData.ginto -= PRICE_ANITO
		PlayerData.has_anito = true
		PlayerData.save_game()
		_update_buy_buttons()
		_show_message("Purchased Anito!")
	else:
		_show_message("Not enough Gold to buy Anito.")


func _show_message(text: String) -> void:
	# Simple transient label popup near top-center
	var lbl = Label.new()
	lbl.text = text
	lbl.add_theme_font_override("font", title.get_theme_font("normal_font"))
	lbl.horizontal_alignment = 1

	var width := 400.0
	var height := 40.0
	var vp_size := get_viewport().get_visible_rect().size
	var center_x := vp_size.x * 0.5
	lbl.position = Vector2(center_x - width * 0.5, 20)
	lbl.size = Vector2(width, height)
	add_child(lbl)

	# auto-remove
	await get_tree().create_timer(2.0).timeout
	lbl.queue_free()


func _open_item_info(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
