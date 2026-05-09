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
		"alipin_namamahay_done"
	):
		return

	if QuestManager.get_state(
		"alipin_saguiguilid_done"
	):
		return

	dialogue_started = true

	interact_button.visible = false

	var dialogue = [

"""
Magandang araw, dayuhan.
""",

"""
Ako ang aliping saguiguilid.
""",

"""
Ako ay nakatira sa bahay ng aking amo at araw-araw na naglilingkod sa kanya.
""",

"""
Mas mabigat ang tungkulin naming mga Alipin Saguiguilid kaysa sa Namamahay.
"""
	]

	dialogue_box.start(
		"ALIPING SAGUIGUILID",
		dialogue
	)

	await dialogue_box.dialogue_finished

	QuestManager.set_state(
		"alipin_saguiguilid_done",
		true
	)

	QuestManager.complete_quest(
		"ALIPIN"
	)

	QuestManager.unlock_quest(
		"MAHARLIKA"
	)

	QuestManager.set_quest(
		{
			"text":
			"Pumunta kay MAHARLIKA",

			"target":
			get_parent().get_node(
				"MaharlikaNPC"
			)
		}
	)

	dialogue_started = false

	if player_inside:
		interact_button.visible = true
