extends CharacterBody2D

var player_inside = false
var dialogue_started = false
var escorting = false

@export var move_speed = 80
@onready var interact_button =$"../MobileUI/InteractButton"
@onready var dialogue_box =$"../DialogueBox"
@onready var sprite = $AnimatedSprite2D
@onready var exit_point =$"../ExitPoint"
func _ready():

	sprite.play("idle")

func _physics_process(delta):

	if escorting:

		var direction =global_position.direction_to(exit_point.global_position)

		velocity = direction * move_speed

		move_and_slide()

		if sprite.animation != "move":
			sprite.play("move")

		sprite.flip_h = direction.x < 0

		if global_position.distance_to(
			exit_point.global_position
		) < 10:

			escorting = false

			visible = false

	else:

		velocity = Vector2.ZERO

		if sprite.animation != "idle":
			sprite.play("idle")

	if player_inside \
	and !dialogue_started \
	and Input.is_action_just_pressed("interact"):

		start_dialogue()
func start_dialogue():

	dialogue_started = true

	interact_button.visible = false

	var dialogue = [

"""
Mukang hindi ka taga rito dahil kakaiba ang iyong pananamit.
""",
"""
Ikaw ba ay naliligaw?
""",
"""
Nasa aming barangay ka.
""",

"""
Dadalhin kita sa aming MAGINOO.
"""
]

	dialogue_box.start(
		"TIMAWA",
		dialogue
	)

	await dialogue_box.dialogue_finished

	begin_escort()

func begin_escort():

	escorting = true

func _on_area_2d_body_entered(body):

	if body.is_in_group("player"):

		player_inside = true

		interact_button.visible = true

func _on_area_2d_body_exited(body):

	if body.is_in_group("player"):

		player_inside = false

		interact_button.visible = false
