extends Control

@onready var rope_bar =$RopeProgressBar
@onready var rope_sprite = $RopeSprite
@onready var marker = $Marker

@onready var dialogue_box =$DialogueBox

@onready var pull_button =$PullButton

@onready var timer =$Timer

@onready var timer_label =$TimerLabel
@onready var maharlika = $Maharlika
@onready var maharlika2 = $Maharlika2

@onready var enemy = $Enemy
@onready var enemy2 = $Enemy2
var rope_value = 50

@export var base_enemy_force = 10.0
@export var max_enemy_force = 18.0

@export var player_force = 4.0
@export var late_pull_threshold = 75.0
@export var late_pull_multiplier = 0.6

var game_finished = false

var game_started = false
var player_pull_timer = 0.0

var rope_left_x = 0.0
var rope_right_x = 0.0
var rope_center_y = 0.0
const WIN_THRESHOLD = 99.0
@export var win_margin_px = 8.0

func _ready():
	play_steady()
	rope_bar.min_value = 0
	rope_bar.max_value = 100
	rope_bar.value = 100

	await get_tree().process_frame
	cache_rope_bar_rect()
	update_marker_position()

	start_tutorial()

func start_tutorial():

	pull_button.disabled = true

	var dialogue = [

"""
Hilaan Lubid!
""",

"""
Pindutin ang PULL button para hilahin ang lubid.
""",

"""
Kapag umabot sa kanan ang lubid,
ikaw ang mananalo.
"""
	]

	dialogue_box.start(
		"TUTORIAL",
		dialogue
	)

	await dialogue_box.dialogue_finished

	pull_button.disabled = false

	game_started = true

	timer.start()

func _process(delta):

	if game_finished:
		return

	if !game_started:
		return

	player_pull_timer -= delta

	if player_pull_timer <= 0.0:
		play_enemy_pull()

	var enemy_force = get_enemy_force()
	rope_value -= enemy_force * delta

	rope_value = clamp(
		rope_value,
		0,
		100
	)

	timer_label.text = str(
		int(timer.time_left)
	)

	update_marker_position()

	check_game_result()

func _on_pull_button_pressed():

	if game_finished:
		return
	
	if !game_started:
		return

	player_pull_timer = 0.20

	play_player_pull()

	rope_value += get_player_force()
	rope_value = clamp(
		rope_value,
		0,
		100
	)

	update_marker_position()
	check_game_result()

func check_game_result():

	if rope_value >= WIN_THRESHOLD \
	or is_marker_at_right_end():

		win_game()

	elif rope_value <= 0:

		lose_game()

func get_enemy_force():

	if timer.is_stopped() or timer.wait_time <= 0.0:
		return base_enemy_force

	var progress = 1.0 - (timer.time_left / timer.wait_time)
	progress = clamp(progress, 0.0, 1.0)

	return lerp(
		base_enemy_force,
		max_enemy_force,
		progress
	)

func get_player_force():

	if rope_value >= late_pull_threshold:
		return player_force * late_pull_multiplier

	return player_force

func is_marker_at_right_end():

	return marker.global_position.x \
	+ marker.size.x \
	>= rope_right_x - win_margin_px

func cache_rope_bar_rect():

	var bar_rect = rope_bar.get_global_rect()

	if is_instance_valid(rope_sprite):
		var sprite_rect = rope_sprite.get_global_rect()
		if sprite_rect.size.x > 0.0:
			bar_rect = sprite_rect

	rope_left_x = bar_rect.position.x
	rope_right_x = bar_rect.position.x + bar_rect.size.x
	rope_center_y = bar_rect.position.y + (bar_rect.size.y * 0.5)

func update_marker_position():

	var t = clamp(
		rope_value,
		0.0,
		100.0
	) / 100.0

	var target_x = lerp(
		rope_left_x,
		rope_right_x,
		t
	)

	marker.global_position = Vector2(
		target_x - (marker.size.x * 0.5),
		rope_center_y - (marker.size.y * 0.2)
	)

func play_steady():

	maharlika.play("steady")
	maharlika2.play("steady")
	enemy.play("steady")
	enemy2.play("steady")

func play_player_pull():

	maharlika.play("pulling")
	maharlika2.play("pulling")
	enemy.play("pulled")
	enemy2.play("pulled")

func play_enemy_pull():

	maharlika.play("pulled")
	maharlika2.play("pulled")
	enemy.play("pulling")
	enemy2.play("pulling")

func win_game():

	game_finished = true

	print("PLAYER WON")

	QuestManager.set_state(
		"rope_game_complete",
		true
	)

	await get_tree().create_timer(
		1.0
	).timeout

	get_tree().change_scene_to_file(
        "res://quiz/maharlika_quiz.tscn"
	)

func lose_game():

	game_finished = true

	print("PLAYER LOST")

	await get_tree().create_timer(
		1.0
	).timeout

	get_tree().reload_current_scene()

func _on_timer_timeout():

	if game_finished:
		return

	lose_game()
