extends Node2D

@onready var player = $Player
@onready var spawn = $PlayerSpawn
@onready var dialogue_box =$DialogueBox
@onready var timer = $Timer
@onready var timer_label =$CanvasLayer/TimerLabel
@onready var countdown_layer = $CountdownLayer
@onready var countdown_label = $CountdownLayer/CountdownLabel
@onready var countdown_rect = $CountdownLayer/ColorRect
@onready var countdown_material = countdown_rect.material as ShaderMaterial

const COUNTDOWN_SECONDS = 10
const COUNTDOWN_HOLE_RADIUS = 72.0
const COUNTDOWN_EDGE = 12.0
const COUNTDOWN_SPOTLIGHT_OFFSET = Vector2(400.0, 240.0)

@export var default_alipin_count = 4

var time_left = 60
var found_count = 0
var countdown_active = false
var target_alipin_count = 0

func _ready():

	player.global_position =spawn.global_position
	player.facing = "back"
	player.update_animation(Vector2.ZERO)

	if countdown_layer:
		countdown_layer.visible = false

	if countdown_material:
		countdown_material.set_shader_parameter(
			"hole_radius_px",
			COUNTDOWN_HOLE_RADIUS
		)
		countdown_material.set_shader_parameter(
			"edge_px",
			COUNTDOWN_EDGE
		)

	setup_alipin_spawns()

	start_tutorial()

func _process(delta):

	if countdown_active:
		update_countdown_spotlight()

func start_tutorial():

	player.can_move = false

	var dialogue = [

"""
Hanapin ang mga nawawalang alipin.
""",

"""
Mayroon kang 60 segundo.
""",

"""
Kapag hindi mo sila nahanap,
uulit ang laro.
"""
	]

	dialogue_box.start(
		"TUTORIAL",
		dialogue
	)

	await dialogue_box.dialogue_finished

	await start_countdown()

	player.can_move = true

	start_game()

func setup_alipin_spawns():

	var hidden_alipin_nodes = get_tree().get_nodes_in_group("hidden_alipin")

	if hidden_alipin_nodes.is_empty():
		return

	var spawn_positions = []
	var spawn_markers = get_tree().get_nodes_in_group("alipin_spawn")

	for marker in spawn_markers:
		if marker is Node2D:
			spawn_positions.append(marker.global_position)

	if spawn_positions.is_empty():
		target_alipin_count = hidden_alipin_nodes.size()
		for node in hidden_alipin_nodes:
			if node.has_method("set_active"):
				node.set_active(true)
		return

	spawn_positions.shuffle()
	hidden_alipin_nodes.shuffle()

	var active_count = min(
		default_alipin_count,
		spawn_positions.size(),
		hidden_alipin_nodes.size()
	)

	target_alipin_count = active_count

	for index in range(hidden_alipin_nodes.size()):
		var node = hidden_alipin_nodes[index]
		var is_active = index < active_count

		if is_active:
			node.global_position = spawn_positions[index]

		if node.has_method("set_active"):
			node.set_active(is_active)
		else:
			node.visible = is_active
			node.set_process(is_active)
			if node is Area2D:
				node.monitoring = is_active
				node.monitorable = is_active

func start_countdown():

	if !countdown_layer or !countdown_label:
		await get_tree().create_timer(COUNTDOWN_SECONDS).timeout
		return

	countdown_layer.visible = true
	countdown_active = true

	update_countdown_spotlight()

	for count in range(COUNTDOWN_SECONDS, 0, -1):
		countdown_label.text = str(count)
		await get_tree().create_timer(1.0).timeout

	countdown_active = false
	countdown_layer.visible = false

func update_countdown_spotlight():

	if !countdown_material:
		return

	var screen_pos = player.global_position
	var viewport = get_viewport()

	if viewport:
		var camera = viewport.get_camera_2d()
		var viewport_size = viewport.get_visible_rect().size

		if camera:
			var screen_center = camera.get_screen_center_position()
			screen_pos = (player.global_position - screen_center) + (viewport_size * 0.5)
		else:
			screen_pos = player.get_global_transform_with_canvas().origin

	countdown_material.set_shader_parameter(
		"hole_center_px",
		screen_pos + COUNTDOWN_SPOTLIGHT_OFFSET
	)

func start_game():

	timer.start()

func _on_timer_timeout():

	time_left -= 1

	timer_label.text =str(time_left)

	if time_left <= 0:

		lose_game()

func found_alipin():

	found_count += 1

	print(
		"FOUND:",
		found_count
	)

	var win_target = target_alipin_count
	if win_target <= 0:
		win_target = 5

	if found_count >= win_target:

		win_game()

func win_game():

	timer.stop()

	QuestManager.set_state(
		"hide_seek_complete",
		true
	)

	get_tree().change_scene_to_file(
        "res://quiz/hide_seek_quiz.tscn"
	)
	
func lose_game():

	get_tree().reload_current_scene()
