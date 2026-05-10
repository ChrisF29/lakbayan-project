extends Node2D

@onready var player = $Player
@onready var spawn = $PlayerSpawn
@onready var dialogue_box =$DialogueBox
@onready var timer = $Timer
@onready var timer_label =$CanvasLayer/TimerLabel

var time_left = 60
var found_count = 0

func _ready():

    player.global_position =spawn.global_position

    start_tutorial()

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

    player.can_move = true

    start_game()

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

    if found_count >= 3:

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