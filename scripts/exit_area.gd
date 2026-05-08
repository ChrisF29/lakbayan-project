extends Area2D

@onready var fade =$"../FadeLayer"

var transitioning = false

func _on_body_entered(body):

    if transitioning:
        return

    if body.is_in_group("player"):

        transitioning = true

        body.can_move = false

        await fade.fade_out()

        get_tree().change_scene_to_file(
            "res://scenes/info_scene.tscn"
        )