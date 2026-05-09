extends Node2D

@onready var dialogue_box =$DialogueBox
@onready var datu_target =$DatuQuestPoint
@onready var player = $Player
@onready var datu_exit_spawn =$DatuHouseExitSpawn
@onready var quest_timawa =$TimawaQuestNPC

func _ready():

    print(SpawnManager.next_spawn)

    if SpawnManager.next_spawn \
    == "DatuHouseExitSpawn":

        print("SPAWNING OUTSIDE DATU HOUSE")

        player.global_position = \
        datu_exit_spawn.global_position

        quest_timawa.visible = true

        await get_tree().process_frame

        start_timawa_quest_intro()

        print(datu_exit_spawn.global_position)

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

func handle_spawn():

    if SpawnManager.next_spawn \
    == "DatuHouseExitSpawn":

        player.global_position = \
        datu_exit_spawn.global_position

        quest_timawa.visible = true

        await get_tree().process_frame

        start_timawa_quest_intro()

        SpawnManager.next_spawn = ""

func start_timawa_quest_intro():

    player.can_move = false

    var dialogue = [

"""
Halika sasabihin ko sayo ang mga dapat mong gawin.
"""
    ]

    dialogue_box.start(
        "TIMAWA",
        dialogue
    )

    await dialogue_box.dialogue_finished

    player.can_move = true

    unlock_first_quest()

func unlock_first_quest():

    QuestManager.unlock_quest(
        "ALIPIN"
    )

    QuestManager.set_quest(
        {
            "text":
            "Pumunta kay ALIPIN",

            "target":
            $AlipinNPC
        }
    )