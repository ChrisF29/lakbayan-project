extends Area2D

var player_inside = false
var found = false

@onready var interact_button = get_node_or_null("../MobileUI/InteractButton")

func _process(delta):

	if found:
		return

	if player_inside \
	and Input.is_action_just_pressed(
        "interact"
	):

		found_alipin()

func found_alipin():

	found = true

	visible = false

	get_parent().found_alipin()

func _on_body_entered(body):

	if body.is_in_group("player"):

		player_inside = true

		if interact_button:
			interact_button.visible = true

func _on_body_exited(body):

	if body.is_in_group("player"):

		player_inside = false

		if interact_button:
			interact_button.visible = false
