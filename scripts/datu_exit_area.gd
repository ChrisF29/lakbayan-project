extends Area2D

var player_inside = false

@onready var interact_button =$"../MobileUI/InteractButton"

@onready var fade =$"../FadeLayer"

func _process(delta):

    if player_inside \
    and Input.is_action_just_pressed(
        "interact"
    ):

        exit_house()
		
func exit_house():

    await fade.fade_out()

    if QuestManager.get_state(
        "hide_seek_started"
    ) \
    and !QuestManager.get_state(
        "hide_seek_complete"
    ):

        get_tree().change_scene_to_file(
            "res://minigames/hide_seek_area.tscn"
        )
        return

    SpawnManager.next_spawn = "DatuHouseExitSpawn"

    get_tree().change_scene_to_file(
        "res://maps/pre_colonial_main_map.tscn"
    )

func _on_body_entered(body):

    if body.is_in_group("player"):

        player_inside = true

        interact_button.visible = true

func _on_body_exited(body):

    if body.is_in_group("player"):

        player_inside = false

        interact_button.visible = false