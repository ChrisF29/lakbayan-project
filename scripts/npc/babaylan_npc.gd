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

	if QuestManager.get_state(
		"babaylan_help_return_done"
	):
		return

	if QuestManager.get_state(
		"babaylan_help_barter_done"
	):
		dialogue_started = true

		interact_button.visible = false

		var return_dialogue = [

"""
Ang Mga sagradong anito na iyong nakuha ay mahalagang bahagi ng aming pagsasagawa ng mga ritwal para sa aming kapakanan.
""",

"""
Bilang pasasalamat, ibabahagi ko sa iyo ang aming kaalaman tungkol sa mga Babaylan. Kami ang mga pinunong espiritwal ng pamayanan. Nangunguna kami sa mga ritwal, paggagamot, at paghingi ng gabay mula sa mga anito at diwata.
"""
		]

		dialogue_box.start(
			"BABAYLAN",
			return_dialogue
		)

		await dialogue_box.dialogue_finished

		QuestManager.set_state(
			"babaylan_help_return_done",
			true
		)

		QuestManager.complete_quest(
			"Bumalik kay BABAYLAN."
		)

		dialogue_started = false

		if player_inside:
			interact_button.visible = true

		return

	if QuestManager.get_state(
		"babaylan_help_return_pending"
	):
		dialogue_started = true

		interact_button.visible = false

		var return_dialogue = [

"""
Mahusay! Naipakita mo ang iyong liksi at determinasyon.
"""
		]

		dialogue_box.start(
			"BABAYLAN",
			return_dialogue
		)

		await dialogue_box.dialogue_finished

		QuestManager.set_state(
			"babaylan_help_return_pending",
			false
		)

		QuestManager.set_state(
			"babaylan_help_barter_pending",
			true
		)

		QuestManager.complete_quest(
			"Bumalik kay BABAYLAN."
		)

		QuestManager.set_quest(
			{
				"text":
				"Pumunta sa MANGANGALAKAL para sa anito.",

				"target":
				get_parent().get_node_or_null(
					"MangangalakalNPC"
				)
			}
		)

		dialogue_started = false

		if player_inside:
			interact_button.visible = true

		return

	if QuestManager.get_state(
		"babaylan_help_barter_pending"
	):
		return

	if QuestManager.get_state(
		"babaylan_help_done"
	):
		return

	if QuestManager.get_state(
		"babaylan_help_started"
	):
		return

	if QuestManager.get_state(
		"mangangalakal_done"
	) \
	and !QuestManager.get_state(
		"babaylan_help_started"
	):
		dialogue_started = true

		interact_button.visible = false

		var dialogue = [

"""
Magandang araw sa iyo dayuhan, nababalitaan ko ang busilak na pagtulong mo dito sa aming lugar.
""",

"""
Maaari mo ba akong tulungan na kuhain ang mga anito para sa isasagawa kong ritwal at paggagamot?
""",

"""
Andito na ang mga halamang gamot ngunit wala ang mga anito na kailangan sa pagriritwal.
""",

"""
Dahil marami nang nagkakasakit dito sa aming lugar.
"""
		]

		dialogue_box.start(
			"BABAYLAN",
			dialogue
		)

		await dialogue_box.dialogue_finished

		QuestManager.set_state(
			"babaylan_help_started",
			true
		)

		QuestManager.set_state(
			"anito_quest_started",
			true
		)

		QuestManager.complete_quest(
			"Pumunta sa BABAYLAN na nangangailangan ng tulong."
		)

		var anito_target = get_parent().get_node_or_null(
			"RopeGameExitPoint"
		)

		QuestManager.set_quest(
			{
				"text":
				"Kunin ang Sagradong anito.",

				"target":
				anito_target
			}
		)

		dialogue_started = false

		if player_inside:
			interact_button.visible = true

		return

	if !QuestManager.is_unlocked("BABAYLAN"):

		dialogue_started = true

		interact_button.visible = false

		var locked_dialogue = [

"""
Hindi pa kita kailangan.
"""
		]

		dialogue_box.start(
			"BABAYLAN",
			locked_dialogue
		)

		await dialogue_box.dialogue_finished

		dialogue_started = false

		if player_inside:
			interact_button.visible = true

		return

	if QuestManager.get_state(
		"babaylan_done"
	):
		return

	dialogue_started = true

	interact_button.visible = false

	var dialogue = [

"""
Ako ay isang Babaylan ng aming barangay. Kami ang pinunong espiritwal at tagapag-ingat ng mga sinaunang paniniwala at ritwal ng aming pamayanan.
""",

"""
Tungkulin naming manguna sa mga seremonya, magdasal sa mga anito at diwata, at magbigay ng paggagamot gamit ang halamang-gamot at tradisyunal na kaalaman.
""",

"""
Lumalapit sa amin ang mga tao upang humingi ng gabay, pagpapala, at lunas sa karamdaman.
""",

"""
Bilang Babaylan, mahalaga sa amin ang pananampalataya, karunungan, at paglilingkod sa aming komunidad.
"""
	]

	dialogue_box.start(
		"BABAYLAN",
		dialogue
	)

	await dialogue_box.dialogue_finished

	QuestManager.set_state(
		"babaylan_done",
		true
	)

	QuestManager.complete_quest(
		"BABAYLAN"
	)

	QuestManager.set_state(
		"name_reward_ready",
		true
	)

	var naming_ui = get_tree().current_scene.get_node_or_null(
		"NamingUI"
	)

	if naming_ui:
		naming_ui.open()

	QuestManager.set_quest(
		{
			"text":
			"Pangalanan ang karakter mo",
			"target":
			null
		}
	)

	dialogue_started = false

	if player_inside:
		interact_button.visible = true
