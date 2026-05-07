extends Control

@onready var base = $Base
@onready var knob = $Base/Knob

var radius = 30
var dragging = false

var output = Vector2.ZERO

func _ready():

    knob.position = base.size / 2 - knob.size / 2

func _input(event):

    if event is InputEventScreenTouch:

        if event.pressed:

            if get_global_rect().has_point(event.position):

                dragging = true

        else:

            dragging = false

            knob.position = base.size / 2 - knob.size / 2

            output = Vector2.ZERO

    elif event is InputEventScreenDrag and dragging:

        var center = global_position + base.size / 2

        var direction = event.position - center

        if direction.length() > radius:

            direction = direction.normalized() * radius

        knob.position = direction + base.size / 2 - knob.size / 2

        output = direction / radius