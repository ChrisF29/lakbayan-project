extends CharacterBody2D

var player_inside = false
var dialogue_started = false
var escorting = false

@export var move_speed = 80
@onready var interact_button =$"../MobileUI/InteractButton"
@onready var dialogue_box =$"../DialogueBox"
@onready var sprite = $AnimatedSprite2D

func _ready():

	sprite.play("idle")

func _physics_process(delta):

	if sprite.animation != "idle":
		sprite.play("idle")

	if player_inside \
	and !dialogue_started \
	and Input.is_action_just_pressed(
		"interact"
	):
		start_dialogue()

func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):

		player_inside = true

		interact_button.visible = true

func _on_area_2d_body_exited(body):

	if body.is_in_group("player"):

		player_inside = false

		interact_button.visible = false

func start_dialogue():

	if !QuestManager.get_state(
		"barter_intro_done"
	):
		return

	if QuestManager.get_state(
		"barter_shop_unlocked"
	) \
	and QuestManager.get_state(
		"mangangalakal_done"
	):
		open_shop()
		return

	if QuestManager.get_state(
		"mangangalakal_done"
	):
		return

	dialogue_started = true

	interact_button.visible = false

	var dialogue = [

"""
Magandang araw! Isa akong mangangalakal sa lugar na ito.
""",

"""
Sa pamamagitan ng paglalayag sa iba't ibang pamayanan, ako ay nakikipagpalitan ng mga produkto tulad ng palay, isda, perlas, ginto, at iba pang mahahalagang kalakal.
""",

"""
Walang salaping ginagamit kaya ang aming paraan ng pakikipagkalakalan ay sa pamamagitan ng barter o palitan ng produkto.
""",

"""
Bilang isang mangangalakal, mahalaga ang aking papel sa pagdadala ng mga kalakal at pakikipag-ugnayan sa iba't ibang pamayanan upang matugunan ang kanilang pangangailangan.
"""
	]

	dialogue_box.start(
		"MANGANGALAKAL",
		dialogue
	)

	await dialogue_box.dialogue_finished

	QuestManager.set_state(
		"mangangalakal_done",
		true
	)

	QuestManager.set_state(
		"barter_shop_unlocked",
		true
	)

	QuestManager.complete_quest(
		"Pumunta sa MANGANGALAKAL."
	)

	QuestManager.unlock_quest(
		"BABAYLAN"
	)

	QuestManager.set_quest(
		{
			"text":
			"Pumunta sa BABAYLAN na nangangailangan ng tulong.",

			"target":
			get_parent().get_node_or_null(
				"BabaylanNPC"
			)
		}
	)

	dialogue_started = false

	if player_inside:
		interact_button.visible = true

	open_shop()

func open_shop():

	SpawnManager.next_spawn = "MangangalakalNPC"

	get_tree().change_scene_to_file(
		"res://scenes/shop.tscn"
	)
