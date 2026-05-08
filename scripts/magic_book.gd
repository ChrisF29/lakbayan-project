extends Area2D

var player_inside = false

@onready var fade = $"../FadeLayer"
@onready var interact_button = $"../MobileUI/InteractButton"

func _on_body_entered(body):

    if body.is_in_group("player"):

        player_inside = true

        interact_button.visible = true

        interact_button.modulate.a = 0

        var tween = create_tween()

        tween.tween_property(
            interact_button,
            "modulate:a",
            1,
            0.2
        )

func _on_body_exited(body):

    if body.is_in_group("player"):

        player_inside = false

        var tween = create_tween()

        tween.tween_property(
            interact_button,
            "modulate:a",
            0,
            0.2
        )

        await tween.finished

        interact_button.visible = false

func _process(delta):

    if player_inside and Input.is_action_just_pressed("interact"):

        interact()

func interact():

    await fade.fade_out()

    get_tree().change_scene_to_file(
        "res://maps/pre_colonial_map_intro.tscn"
    )
