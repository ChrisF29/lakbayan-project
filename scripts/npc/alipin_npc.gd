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

	if !QuestManager.is_unlocked("ALIPIN"):
		return

	if QuestManager.get_state(
		"alipin_namamahay_done"
	):
		return

	dialogue_started = true

	interact_button.visible = false

	var dialogue = [

"""
Magandang araw, dayuhan.
""",

"""
Ako ay isang Aliping Namamahay.
""",

"""
May sarili kaming tahanan at maaaring magkaroon ng pamilya.
""",

"""
Naglilingkod lamang kapag kinakailangan ng amo.
""",

"""
May isa pang uri ng alipin.
"""
	]

	dialogue_box.start(
		"ALIPIN NAMAMAHAY",
		dialogue
	)

	await dialogue_box.dialogue_finished

	QuestManager.set_state(
		"alipin_namamahay_done",
		true
	)

	QuestManager.set_quest(
		{
			"text":
			"Kausapin ang isa pang ALIPIN.",

			"target":
			get_parent().get_node(
				"SaguiguilidNPC"
			)
		}
	)

	dialogue_started = false

	if player_inside:
		interact_button.visible = true
