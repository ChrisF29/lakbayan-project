extends Node

signal quest_updated

var current_quest = ""
var current_target = null
var village_intro_done = false
var maharlika_arc_started = false

var completed_quests = []
var unlocked_quests = []
var quest_states = {}

func set_quest(new_quest, new_target = null):

    if typeof(new_quest) == TYPE_DICTIONARY and new_target == null:
        current_quest = new_quest.get("text", "")
        current_target = new_quest.get("target", null)
    else:
        current_quest = new_quest
        current_target = new_target

    quest_updated.emit()

func unlock_quest(quest_name):

    if !unlocked_quests.has(
        quest_name
    ):

        unlocked_quests.append(
            quest_name
        )

func is_unlocked(quest_name):

    return unlocked_quests.has(
        quest_name
    )

func complete_quest(quest_name):

    if !completed_quests.has(
        quest_name
    ):

        completed_quests.append(
            quest_name
        )

    if current_quest == quest_name:

        current_quest = ""
        current_target = null

    quest_updated.emit()

func is_completed(quest_name):

    return completed_quests.has(
        quest_name
    )

func set_state(key, value):

    quest_states[key] = value

func get_state(key):

    if quest_states.has(key):
        return quest_states[key]

    return null