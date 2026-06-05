extends Area2D

var transitioning = false
var quest_active = false

@onready var fade = $"../FadeLayer"
@onready var blocker_shape = get_node_or_null(
	"QuestBlocker/CollisionShape2D"
)

func _ready():

	update_blocker()
	set_process(!quest_active)

func _process(_delta):

	var active = _is_rope_game_active() \
	or _is_anito_quest_active()

	if active == quest_active:
		return

	quest_active = active
	update_blocker()

	if quest_active:
		set_process(false)

func update_blocker():

	quest_active = _is_rope_game_active() \
	or _is_anito_quest_active()

	if blocker_shape != null:
		blocker_shape.disabled = quest_active

func start_game():

	if transitioning:
		return

	if !_is_rope_game_active() \
	and !_is_anito_quest_active():
		return

	transitioning = true

	await fade.fade_out()

	if _is_rope_game_active():
		get_tree().change_scene_to_file(
			"res://minigames/hilaan_lubid.tscn"
		)
		return

	get_tree().change_scene_to_file(
		"res://quiz/babaylan_quiz.tscn"
	)

func _is_rope_game_active() -> bool:

	return QuestManager.get_state(
		"rope_game_started"
	) == true \
	and QuestManager.get_state(
		"rope_game_complete"
	) != true

func _is_anito_quest_active() -> bool:

	return QuestManager.get_state(
		"anito_quest_started"
	) == true \
	and QuestManager.get_state(
		"anito_quest_complete"
	) != true

func _on_body_entered(body):

	if body.is_in_group("player"):
		start_game()
