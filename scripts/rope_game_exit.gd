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

	var active = QuestManager.get_state(
		"rope_game_started"
	) == true

	if active == quest_active:
		return

	quest_active = active
	update_blocker()

	if quest_active:
		set_process(false)

func update_blocker():

	quest_active = QuestManager.get_state(
		"rope_game_started"
	) == true

	if blocker_shape != null:
		blocker_shape.disabled = quest_active

func start_game():

	if transitioning:
		return

	if !QuestManager.get_state(
		"rope_game_started"
	):
		return

	transitioning = true

	await fade.fade_out()

	get_tree().change_scene_to_file(
		"res://minigames/hilaan_lubid.tscn"
	)

func _on_body_entered(body):

	if body.is_in_group("player"):
		start_game()
