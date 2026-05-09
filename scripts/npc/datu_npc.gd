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
		"player_named"
	):
		return

	if QuestManager.get_state(
		"hide_seek_started"
	):
		return

	dialogue_started = true

	interact_button.visible = false

	var dialogue = [

"""
Ipinatawag kita dahil kailangan ko ang tulong mo """ \
+ PlayerData.player_name + """
""",

"""
Maraming nawawala sa aking mga alipin.
""",

"""
Maaari mo bang hanapin ang mga nawawala kong alipin?
"""
	]

	dialogue_box.start(
		"DATU",
		dialogue
	)

	await dialogue_box.dialogue_finished

	QuestManager.set_state(
		"hide_seek_started",
		true
	)

	var hide_seek_exit_point = get_parent().get_node_or_null(
		"HideSeekExitPoint"
	)

	QuestManager.set_quest(
		{
			"text":
			"Hanapin ang mga Alipin.",

			"target":
			hide_seek_exit_point
		}
	)

	dialogue_started = false

	if player_inside:
		interact_button.visible = true
