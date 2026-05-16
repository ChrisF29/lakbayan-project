extends CanvasLayer

@onready var arrow = $Arrow

var target = null
@export var edge_margin = 24.0

func _ready():

	QuestManager.quest_updated.connect(
		update_target
	)

	update_target()

	arrow.pivot_offset = arrow.size * 0.5

func update_target():

	target = QuestManager.current_target

func _process(delta):

	if target == null \
	or !is_instance_valid(target):
		arrow.visible = false
		return

	arrow.visible = true

	var player = get_tree() \
	.get_first_node_in_group("player")

	if player == null:
		return

	var to_target = target.global_position - player.global_position

	if to_target.length() < 0.001:
		arrow.visible = false
		return

	var viewport_rect = get_viewport().get_visible_rect()
	var target_screen = get_viewport().get_canvas_transform() * \
		target.global_position

	if viewport_rect.has_point(target_screen):
		arrow.visible = false
		return

	var direction = to_target.normalized()

	arrow.rotation = direction.angle() + deg_to_rad(90)
	var center = viewport_rect.size * 0.5
	var max_x = max(
		center.x - edge_margin,
		0.0
	)
	var max_y = max(
		center.y - edge_margin,
		0.0
	)

	var scale_x = INF
	var scale_y = INF

	if abs(direction.x) > 0.0001:
		scale_x = max_x / abs(direction.x)

	if abs(direction.y) > 0.0001:
		scale_y = max_y / abs(direction.y)

	var scale = min(scale_x, scale_y)
	var screen_pos = center + direction * scale

	arrow.position = screen_pos - arrow.pivot_offset
