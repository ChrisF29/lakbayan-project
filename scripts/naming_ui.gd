extends CanvasLayer

@onready var input =$Panel/VBoxContainer/NameInput
@onready var player_data = get_node_or_null("/root/PlayerData")

func open():

    visible = true

    if player_data:
        input.text = player_data.player_name
    else:
        input.text = ""
    input.grab_focus()
    input.select_all()

func _on_confirm_button_pressed():

    var entered_name = \
    input.text.strip_edges()

    if entered_name == "":
        return

    if player_data:
        player_data.player_name = entered_name

    QuestManager.set_state(
        "player_named",
        true
    )

    visible = false

    var datu_target = get_tree().current_scene.get_node_or_null(
        "DatuQuestPoint"
    )

    QuestManager.set_quest(
        {
            "text":
            "Bumalik sa DATU",

            "target":
            datu_target
        }
    )

    if player_data:
        print(
            "PLAYER NAME:",
            player_data.player_name
        )