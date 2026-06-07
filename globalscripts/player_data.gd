extends Node

var player_name = "Dayuhan"
var ginto = 0
var perlas = 0
var has_kampilan = false
var has_bangkaw = false
var has_anito = false

const SAVE_PATH := "user://save_game.json"

var _pending_scene_path = ""
var _pending_player_position = null
var _pending_restore = false


func reset_game() -> bool:
	player_name = "Dayuhan"
	ginto = 0
	perlas = 0
	has_kampilan = false
	has_bangkaw = false
	has_anito = false

	QuestManager.current_quest = ""
	QuestManager.current_target = null
	QuestManager.village_intro_done = false
	QuestManager.maharlika_arc_started = false
	QuestManager.completed_quests.clear()
	QuestManager.unlocked_quests.clear()
	QuestManager.quest_states.clear()

	SpawnManager.next_spawn = ""

	_pending_scene_path = ""
	_pending_player_position = null
	_pending_restore = false

	return save_game()

func save_game() -> bool:

	var save_data = _build_save_data()

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	if file == null:
		push_error(
			"Failed to open save file. Code: %s" %
			FileAccess.get_open_error()
		)
		return false

	file.store_string(
		JSON.stringify(save_data)
	)

	return true

func load_game() -> Dictionary:

	if !FileAccess.file_exists(
		SAVE_PATH
	):
		return {}

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)

	if file == null:
		push_error(
			"Failed to open save file. Code: %s" %
			FileAccess.get_open_error()
		)
		return {}

	var data = JSON.parse_string(
		file.get_as_text()
	)

	if typeof(data) != TYPE_DICTIONARY:
		return {}

	_apply_save_data(data)
	_queue_restore_from_data(data)

	return data

func _build_save_data() -> Dictionary:

	var scene_path = ""
	var player_position = null

	var current_scene = get_tree().current_scene

	if current_scene:
		scene_path = current_scene.scene_file_path

		var player_node = current_scene.get_node_or_null(
			"Player"
		)

		if player_node != null \
		and player_node is Node2D:
			player_position = {
				"x": player_node.global_position.x,
				"y": player_node.global_position.y
			}

	return {
		"version": 1,
		"scene": {
			"path": scene_path,
			"player_position": player_position
		},
		"player": {
			"name": player_name,
			"ginto": ginto,
			"perlas": perlas,
			"has_kampilan": has_kampilan,
			"has_bangkaw": has_bangkaw,
			"has_anito": has_anito
		},
		"quest": {
			"current_quest": QuestManager.current_quest,
			"village_intro_done": QuestManager.village_intro_done,
			"maharlika_arc_started": QuestManager.maharlika_arc_started,
			"completed": QuestManager.completed_quests,
			"unlocked": QuestManager.unlocked_quests,
			"states": QuestManager.quest_states
		},
		"spawn": {
			"next_spawn": SpawnManager.next_spawn
		}
	}

func _apply_save_data(data: Dictionary) -> void:

	var player_data = data.get(
		"player",
		{}
	)

	if typeof(player_data) == TYPE_DICTIONARY:
		player_name = player_data.get(
			"name",
			player_name
		)
		ginto = player_data.get(
			"ginto",
			ginto
		)
		perlas = player_data.get(
			"perlas",
			perlas
		)
		has_kampilan = player_data.get(
			"has_kampilan",
			has_kampilan
		)
		has_bangkaw = player_data.get(
			"has_bangkaw",
			has_bangkaw
		)
		has_anito = player_data.get(
			"has_anito",
			has_anito
		)

	var quest_data = data.get(
		"quest",
		{}
	)

	if typeof(quest_data) == TYPE_DICTIONARY:
		QuestManager.village_intro_done = quest_data.get(
			"village_intro_done",
			QuestManager.village_intro_done
		)
		QuestManager.maharlika_arc_started = quest_data.get(
			"maharlika_arc_started",
			QuestManager.maharlika_arc_started
		)
		QuestManager.completed_quests = quest_data.get(
			"completed",
			QuestManager.completed_quests
		)
		QuestManager.unlocked_quests = quest_data.get(
			"unlocked",
			QuestManager.unlocked_quests
		)
		QuestManager.quest_states = quest_data.get(
			"states",
			QuestManager.quest_states
		)

		var current_quest = quest_data.get(
			"current_quest",
			""
		)

		QuestManager.set_quest(
			current_quest
		)

	var spawn_data = data.get(
		"spawn",
		{}
	)

	if typeof(spawn_data) == TYPE_DICTIONARY:
		SpawnManager.next_spawn = spawn_data.get(
			"next_spawn",
			SpawnManager.next_spawn
		)

func _queue_restore_from_data(data: Dictionary) -> void:

	var scene_data = data.get(
		"scene",
		{}
	)

	if typeof(scene_data) != TYPE_DICTIONARY:
		return

	var scene_path = scene_data.get(
		"path",
		""
	)

	var position_data = scene_data.get(
		"player_position",
		null
	)

	if scene_path == "" \
	or typeof(position_data) != TYPE_DICTIONARY:
		return

	var pos_x = position_data.get(
		"x",
		null
	)
	var pos_y = position_data.get(
		"y",
		null
	)

	if pos_x == null or pos_y == null:
		return

	_pending_scene_path = scene_path
	_pending_player_position = Vector2(
		float(pos_x),
		float(pos_y)
	)
	_pending_restore = true

	var tree = get_tree()

	if !tree.scene_changed.is_connected(
		_on_scene_changed
	):
		tree.scene_changed.connect(
			_on_scene_changed
		)

func _on_scene_changed() -> void:

	if !_pending_restore:
		return

	var current_scene = get_tree().current_scene

	if current_scene == null:
		return

	if current_scene.scene_file_path != _pending_scene_path:
		return

	var player_node = current_scene.get_node_or_null(
		"Player"
	)

	if player_node != null \
	and player_node is Node2D:
		player_node.global_position = _pending_player_position

	_pending_scene_path = ""
	_pending_player_position = null
	_pending_restore = false

	var tree = get_tree()

	if tree.scene_changed.is_connected(
		_on_scene_changed
	):
		tree.scene_changed.disconnect(
			_on_scene_changed
		)
