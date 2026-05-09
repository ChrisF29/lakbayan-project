extends CanvasLayer

@onready var arrow = $Arrow

var target = null

func _ready():

	QuestManager.quest_updated.connect(
		update_target
	)

	update_target()

func update_target():

	target = QuestManager.current_target

func _process(delta):

	if target == null:
		arrow.visible = false
		return

	arrow.visible = true

	var player = get_tree() \
	.get_first_node_in_group("player")

	if player == null:
		return

	var direction = \
	player.global_position.direction_to(
		target.global_position
	)

	arrow.rotation = \
	direction.angle() + deg_to_rad(90)
