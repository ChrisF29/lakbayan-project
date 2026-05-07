extends Parallax2D

@export var base_speed := 20.0
@export var layer_speed_multipliers: Array[float] = [0.2, 0.4, 0.7, 1.0]

var layers: Array[Node2D] = []
var start_positions: Array[Vector2] = []
var scroll_x := 0.0

func _ready():

    scroll_offset = Vector2.ZERO

    for child in get_children():

        if child is Node2D:
            layers.append(child)
            start_positions.append(child.position)

func _process(delta):

    scroll_x -= base_speed * delta

    for i in layers.size():

        var multiplier = 1.0

        if i < layer_speed_multipliers.size():
            multiplier = layer_speed_multipliers[i]

        var pos = start_positions[i]
        pos.x += scroll_x * multiplier
        layers[i].position = pos