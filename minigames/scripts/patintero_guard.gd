extends CharacterBody2D

@export var left_limit: float = 80.0
@export var right_limit: float = 420.0

@export var patrol_speed: float = 120.0
@export var chase_speed: float = 200.0

@onready var player = get_tree().get_first_node_in_group("player")

var direction: int = 1
var player_detected := false

func _physics_process(delta):

	if player == null:
		move_and_slide()
		return

	if player_detected:

		if player.global_position.x > global_position.x:

			velocity.x = chase_speed

		elif player.global_position.x < global_position.x:

			velocity.x = -chase_speed

		else:

			velocity.x = 0

	else:

		velocity.x = patrol_speed * direction

		if global_position.x >= right_limit:

			direction = -1

		elif global_position.x <= left_limit:

			direction = 1

	move_and_slide()

	global_position.x = clamp(
		global_position.x,
		left_limit,
		right_limit
	)

func _on_detection_area_body_entered(body):
	
	print("ENTERED:", body.name)

	if body.is_in_group("player"):

		print("PLAYER DETECTED")

		player_detected = true

func _on_detection_area_body_exited(body):

	print("EXITED:", body.name)

	if body.is_in_group("player"):

		print("PLAYER LEFT")

		player_detected = false

func _on_catch_area_body_entered(body):

	if body.is_in_group("player"):

		player_caught()

func player_caught():

	var scene = get_tree().current_scene

	if scene != null and scene.has_method("player_caught"):

		scene.player_caught()
		return

	get_tree().reload_current_scene()
