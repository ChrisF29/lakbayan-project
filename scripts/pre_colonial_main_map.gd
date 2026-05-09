extends Node2D

@onready var dialogue_box =$DialogueBox
@onready var datu_target =$DatuQuestPoint
@onready var player = $Player
@onready var datu_exit_spawn =$DatuHouseExitSpawn

func _ready():

    if SpawnManager.next_spawn \
    == "datu_house_exit":

        player.global_position = \
        datu_exit_spawn.global_position

        SpawnManager.next_spawn = ""

    if !QuestManager.village_intro_done:

        QuestManager.village_intro_done = true

        await get_tree().process_frame

        start_intro()

func start_intro():

    var dialogue = [

"""
Nandito na tayo sa aming barangay.
"""
    ]

    dialogue_box.start(
        "TIMAWA",
        dialogue
    )

    await dialogue_box.dialogue_finished

    QuestManager.set_quest(
        {
            "text": "Pumunta sa DATU o MAGINOO.",
            "target": datu_target
        }
    )