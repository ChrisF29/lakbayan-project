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

	if !QuestManager.is_unlocked("TIMAWA"):

		dialogue_started = true

		interact_button.visible = false

		var locked_dialogue = [

"""
Hindi pa kita kailangan.
"""
		]

		dialogue_box.start(
			"TIMAWA",
			locked_dialogue
		)

		await dialogue_box.dialogue_finished

		dialogue_started = false

		if player_inside:
			interact_button.visible = true

		return

	if QuestManager.get_state(
		"timawa_done"
	):
		return

	dialogue_started = true

	interact_button.visible = false

	var dialogue = [

"""
Ako ay isang Timawa ng aming barangay. Kami ay malalayang mamamayan na naglilingkod sa datu at tumutulong sa pamayanan.
""",

"""
Marami sa amin ay mga mandirigma, mangingisda, magsasaka, o mangangalakal.
""",

"""
Hindi kami alipin at may karapatan kaming magkaroon ng sariling ari-arian at pamilya.
""",

"""
Kabilang din kami sa mga sumasama sa paglalakbay at pakikipagdigma upang ipagtanggol ang aming barangay.
""",

"""
Bilang Timawa, ipinagmamalaki namin ang aming katapatan, kasipagan, at katapangan.
"""
	]

	dialogue_box.start(
		"TIMAWA",
		dialogue
	)

	await dialogue_box.dialogue_finished

	QuestManager.set_state(
		"timawa_done",
		true
	)

	QuestManager.complete_quest(
		"TIMAWA"
	)

	QuestManager.unlock_quest(
		"BABAYLAN"
	)

	QuestManager.set_quest(
		{
			"text":
			"Pumunta kay BABAYLAN",

			"target":
			get_parent().get_node(
				"BabaylanNPC"
			)
		}
	)

	dialogue_started = false

	if player_inside:
		interact_button.visible = true
