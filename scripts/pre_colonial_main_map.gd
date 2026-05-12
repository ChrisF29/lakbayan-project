extends Node2D

@onready var dialogue_box =$DialogueBox
@onready var datu_target =$DatuQuestPoint
@onready var player = $Player
@onready var datu_exit_spawn =$DatuHouseExitSpawn
@onready var quest_timawa =$TimawaQuestNPC
@onready var maharlika_target = get_node_or_null("MaharlikaQuestPoint")

func _ready():

    print(SpawnManager.next_spawn)

    if SpawnManager.next_spawn \
    == "DatuHouseExitSpawn":

        print("SPAWNING OUTSIDE DATU HOUSE")

        player.global_position = \
        datu_exit_spawn.global_position

        quest_timawa.visible = true

        await get_tree().process_frame

        if !QuestManager.get_state(
            "maharlika_arc_started"
        ):
            start_timawa_quest_intro()

        print(datu_exit_spawn.global_position)

        SpawnManager.next_spawn = ""

    if !QuestManager.village_intro_done:

        QuestManager.village_intro_done = true

        await get_tree().process_frame

        start_intro()

    update_maharlika_target()

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

        if !QuestManager.get_state(
            "maharlika_arc_started"
        ):
            start_timawa_quest_intro()

        SpawnManager.next_spawn = ""

func start_timawa_quest_intro():

    if QuestManager.get_state(
        "timawa_intro_done"
    ):
        unlock_first_quest()
        return

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

    QuestManager.set_state(
        "timawa_intro_done",
        true
    )

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

func update_maharlika_target():

    if maharlika_target == null:
        return

    if !QuestManager.get_state(
        "maharlika_arc_started"
    ):
        return

    if QuestManager.current_quest != "Kailangan ka ng MAHARLIKA.":
        return

    var current_target = QuestManager.current_target

    if current_target != null \
    and is_instance_valid(current_target) \
    and current_target.is_inside_tree():
        return

    QuestManager.set_quest(
        {
            "text":
            "Kailangan ka ng MAHARLIKA.",

            "target":
            maharlika_target
        }
    )