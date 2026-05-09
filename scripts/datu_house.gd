extends Node2D

@onready var dialogue_box =$DialogueBox

@onready var player =$Player

func _ready():

    if QuestManager.get_state(
        "datu_intro_done"
    ):
        player.can_move = true
        return

    player.can_move = false

    await get_tree().process_frame

    start_datu_intro()

func start_datu_intro():

    var dialogue = [

"""
Ako ang DATU sa pamayanang ito.
""",

"""
Tila moderno ang iyong kasuotan at bago ka sa aking paningin.
""",

"""
Para makatuloy ka rito sa aming lugar ay kailangan mo muna malaman ang mga paniniwala, kultura at pamumuhay ng lugar.
""",

"""
At ang mga mission na ibibigay sayo.
""",

"""
Ang Timawang nagdala sayo dito ang bahala para malaman mo kung ano ang mga dapat mong malaman sa lugar na ito.
"""
    ]

    dialogue_box.start(
        "DATU",
        dialogue
    )

    await dialogue_box.dialogue_finished

    finish_datu_intro()

func finish_datu_intro():

    QuestManager.complete_quest(
        "Pumunta sa DATU o MAGINOO."
    )

    QuestManager.set_state(
        "datu_intro_done",
        true
    )

    player.can_move = true

    print("DATU QUEST COMPLETE")