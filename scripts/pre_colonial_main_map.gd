extends Node2D

@onready var dialogue_box =$DialogueBox
@onready var datu_target =$DatuQuestPoint
@onready var player = $Player
@onready var datu_exit_spawn =$DatuHouseExitSpawn
@onready var quest_timawa =$TimawaQuestNPC
@onready var maharlika_target = get_node_or_null("MaharlikaQuestPoint")
@onready var mangangalakal_target = get_node_or_null("MangangalakalNPC")
@onready var babaylan_target = get_node_or_null("BabaylanNPC")
@onready var rope_exit_target = get_node_or_null("RopeGameExitPoint")

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

    elif SpawnManager.next_spawn \
    == "MangangalakalNPC":

        if mangangalakal_target != null:
            player.global_position = \
            mangangalakal_target.global_position

        SpawnManager.next_spawn = ""

    if !QuestManager.village_intro_done:

        QuestManager.village_intro_done = true

        await get_tree().process_frame

        start_intro()

    update_maharlika_target()
    update_maharlika_return_target()
    update_barter_datu_target()
    update_mangangalakal_target()
    update_babaylan_barter_target()
    update_babaylan_intro_target()
    update_babaylan_help_target()
    update_babaylan_return_target()
    update_anito_target()

func start_intro():

    var dialogue = [

"""
Nandito na tayo sa aming balangay.
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

    elif SpawnManager.next_spawn \
    == "MangangalakalNPC":

        if mangangalakal_target != null:
            player.global_position = \
            mangangalakal_target.global_position

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

func update_maharlika_return_target():

    if maharlika_target == null:
        return

    if !QuestManager.get_state(
        "rope_game_complete"
    ):
        return

    if QuestManager.get_state(
        "maharlika_final_done"
    ):
        return

    var current_target = QuestManager.current_target

    if current_target != null \
    and is_instance_valid(current_target) \
    and current_target.is_inside_tree():
        if QuestManager.current_quest == "Pumunta sa MAHARLIKA.":
            return

    QuestManager.set_quest(
        {
            "text":
            "Pumunta sa MAHARLIKA.",

            "target":
            maharlika_target
        }
    )

func update_barter_datu_target():

    if !QuestManager.get_state(
        "maharlika_final_done"
    ):
        return

    if QuestManager.get_state(
        "barter_intro_done"
    ):
        return

    var current_target = QuestManager.current_target

    if current_target != null \
    and is_instance_valid(current_target) \
    and current_target.is_inside_tree():
        if QuestManager.current_quest == "Pumunta sa DATU.":
            return

    QuestManager.set_quest(
        {
            "text":
            "Pumunta sa DATU.",

            "target":
            datu_target
        }
    )

func update_mangangalakal_target():

    if mangangalakal_target == null:
        return

    if !QuestManager.get_state(
        "barter_intro_done"
    ):
        return

    if QuestManager.get_state(
        "mangangalakal_done"
    ):
        return

    var current_target = QuestManager.current_target

    if current_target != null \
    and is_instance_valid(current_target) \
    and current_target.is_inside_tree():
        if QuestManager.current_quest == "Pumunta sa MANGANGALAKAL.":
            return

    QuestManager.set_quest(
        {
            "text":
            "Pumunta sa MANGANGALAKAL.",

            "target":
            mangangalakal_target
        }
    )

func update_babaylan_barter_target():

    if mangangalakal_target == null:
        return

    if !QuestManager.get_state(
        "babaylan_help_barter_pending"
    ):
        return

    if QuestManager.get_state(
        "babaylan_help_barter_done"
    ):
        return

    if QuestManager.current_quest \
    != "Pumunta sa MANGANGALAKAL para sa anito.":
        return

    var current_target = QuestManager.current_target

    if current_target != null \
    and is_instance_valid(current_target) \
    and current_target.is_inside_tree():
        return

    QuestManager.set_quest(
        {
            "text":
            "Pumunta sa MANGANGALAKAL para sa anito.",

            "target":
            mangangalakal_target
        }
    )

func update_babaylan_help_target():

    if babaylan_target == null:
        return

    if !QuestManager.get_state(
        "mangangalakal_done"
    ):
        return

    if QuestManager.get_state(
        "babaylan_help_started"
    ):
        return

    if QuestManager.current_quest \
    != "Pumunta sa BABAYLAN na nangangailangan ng tulong.":
        return

    var current_target = QuestManager.current_target

    if current_target != null \
    and is_instance_valid(current_target) \
    and current_target.is_inside_tree():
        return

    QuestManager.set_quest(
        {
            "text":
            "Pumunta sa BABAYLAN na nangangailangan ng tulong.",

            "target":
            babaylan_target
        }
    )

func update_babaylan_intro_target():

    if babaylan_target == null:
        return

    if QuestManager.current_quest \
    != "Pumunta kay BABAYLAN":
        return

    var current_target = QuestManager.current_target

    if current_target != null \
    and is_instance_valid(current_target) \
    and current_target.is_inside_tree():
        return

    QuestManager.set_quest(
        {
            "text":
            "Pumunta kay BABAYLAN",

            "target":
            babaylan_target
        }
    )

func update_babaylan_return_target():

    if babaylan_target == null:
        return

    if QuestManager.get_state(
        "babaylan_help_return_done"
    ):
        return

    if QuestManager.current_quest \
    != "Bumalik kay BABAYLAN.":
        return

    var current_target = QuestManager.current_target

    if current_target != null \
    and is_instance_valid(current_target) \
    and current_target.is_inside_tree():
        return

    QuestManager.set_quest(
        {
            "text":
            "Bumalik kay BABAYLAN.",

            "target":
            babaylan_target
        }
    )

func update_anito_target():

    if rope_exit_target == null:
        return

    if !QuestManager.get_state(
        "anito_quest_started"
    ):
        return

    if QuestManager.get_state(
        "anito_quest_complete"
    ):
        return

    if QuestManager.current_quest \
    != "Kunin ang Sagradong anito.":
        return

    var current_target = QuestManager.current_target

    if current_target != null \
    and is_instance_valid(current_target) \
    and current_target.is_inside_tree():
        return

    QuestManager.set_quest(
        {
            "text":
            "Kunin ang Sagradong anito.",

            "target":
            rope_exit_target
        }
    )