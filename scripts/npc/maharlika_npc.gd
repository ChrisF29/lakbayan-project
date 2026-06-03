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

	if !QuestManager.is_unlocked("MAHARLIKA") \
	and !QuestManager.get_state(
		"maharlika_arc_started"
	):

		dialogue_started = true

		interact_button.visible = false

		var locked_dialogue = [

"""
Hindi pa kita kailangan.
"""
		]

		dialogue_box.start(
			"MAHARLIKA",
			locked_dialogue
		)

		await dialogue_box.dialogue_finished

		dialogue_started = false

		if player_inside:
			interact_button.visible = true

		return

	if QuestManager.get_state(
		"maharlika_arc_started"
	) \
	and !QuestManager.get_state(
		"rope_game_started"
	):

		dialogue_started = true

		interact_button.visible = false

		var dialogue = [

"""
Sinabi ng DATU na ikaw ang tumulong para mahanap ang mga nawawalang alipin.
""",

"""
Ngayon kailangan kita.
""",

"""
May mga mandirigma na gustong sakupin ang aming barangay.
"""
		]

		dialogue_box.start(
			"MAHARLIKA",
			dialogue
		)

		await dialogue_box.dialogue_finished

		QuestManager.set_state(
			"rope_game_started",
			true
		)

		QuestManager.set_quest(
			{
				"text":
				"Tulungan si MAHARLIKA.",

				"target":
				$"../RopeGameExitPoint"
			}
		)

		dialogue_started = false

		if player_inside:
			interact_button.visible = true

		return

	if QuestManager.get_state(
		"rope_game_complete"
	) \
	and !QuestManager.get_state(
		"maharlika_final_done"
	):

		dialogue_started = true

		interact_button.visible = false

		var dialogue = [

"""
Salamat sa pinakita mong tapang.
"""
		]

		dialogue_box.start(
			"MAHARLIKA",
			dialogue
		)

		await dialogue_box.dialogue_finished

		QuestManager.set_state(
			"maharlika_final_done",
			true
		)

		var datu_target = get_parent().get_node_or_null(
			"DatuQuestPoint"
		)

		QuestManager.set_quest(
			{
				"text":
				"Pumunta sa DATU.",

				"target":
				datu_target
			}
		)

		dialogue_started = false

		if player_inside:
			interact_button.visible = true

		return

	if QuestManager.get_state(
		"maharlika_done"
	):
		return

	dialogue_started = true

	interact_button.visible = false

	var dialogue = [

"""
Ako ang Maharlika ng aming barangay. Ako ay mandirigma at tagapagtanggol ng pamayanan sa ilalim ng pamumuno ng datu.
""",

"""
Tungkulin naming panatilihin ang kapayapaan, ipagtanggol ang aming lupain, at tumulong sa panahon ng digmaan.
""",

"""
Mayroon kaming kalayaan at karangalan sa lipunan, at kami ay iginagalang dahil sa aming katapatan at katapangan.
""",

"""
Bilang Maharlika, mahalaga sa amin ang dangal, tapang, at paglilingkod sa aming barangay.
"""
	]

	dialogue_box.start(
		"MAHARLIKA",
		dialogue
	)

	await dialogue_box.dialogue_finished

	QuestManager.set_state(
		"maharlika_done",
		true
	)

	QuestManager.complete_quest(
		"MAHARLIKA"
	)

	QuestManager.unlock_quest(
		"TIMAWA"
	)

	QuestManager.set_quest(
		{
			"text":
			"Pumunta kay TIMAWA",

			"target":
			get_parent().get_node(
				"TimawaNPC"
			)
		}
	)

	dialogue_started = false

	if player_inside:
		interact_button.visible = true
