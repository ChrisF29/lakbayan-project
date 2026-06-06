extends CharacterBody2D

@export var speed = 100
@export var dash_speed = 280
@export var dash_duration = 0.16
@export var dash_cooldown = 0.45

@onready var sprite = $AnimatedSprite2D
var facing = "front"
var can_move = true
var follow_target = null
var joystick = null
var dash_time_left = 0.0
var dash_cooldown_left = 0.0
var dash_direction = Vector2.ZERO

func _ready():

    joystick = get_tree().get_first_node_in_group(
        "joystick"
    )

    print(joystick)

func _physics_process(delta):

    if dash_cooldown_left > 0.0:
        dash_cooldown_left = max(
            dash_cooldown_left - delta,
            0.0
        )

    if dash_time_left > 0.0:

        dash_time_left = max(
            dash_time_left - delta,
            0.0
        )

        velocity = dash_direction * dash_speed
        update_animation(dash_direction)
        move_and_slide()
        return

    if !can_move:

        velocity = Vector2.ZERO
        update_animation(Vector2.ZERO)
        move_and_slide()
        return

    var direction = Vector2.ZERO

    if follow_target:

        direction = global_position.direction_to(
            follow_target.global_position
        )

    else:

        if joystick and joystick.output != Vector2.ZERO:

            direction = joystick.output

        else:

            direction = Input.get_vector(
                "left",
                "right",
                "up",
                "down"
            )

    velocity = direction * speed

    update_animation(direction)

    move_and_slide()

func update_animation(direction):

    if direction == Vector2.ZERO:

        var idle_anim = facing + "_idle"

        if sprite.animation != idle_anim:
            sprite.play(idle_anim)

        return

    var move_anim = ""

    if abs(direction.x) > abs(direction.y):

        if direction.x > 0:
            facing = "right"
            move_anim = "right_move"

        else:
            facing = "left"
            move_anim = "left_move"

    else:

        if direction.y > 0:
            facing = "front"
            move_anim = "front_move"

        else:
            facing = "back"
            move_anim = "back_move"

    if sprite.animation != move_anim:
        sprite.play(move_anim)

func try_dash():

    if !can_move:
        return

    if dash_time_left > 0.0:
        return

    if dash_cooldown_left > 0.0:
        return

    dash_direction = _facing_to_vector()
    dash_time_left = dash_duration
    dash_cooldown_left = dash_cooldown

func _facing_to_vector() -> Vector2:

    match facing:
        "right":
            return Vector2.RIGHT
        "left":
            return Vector2.LEFT
        "back":
            return Vector2.UP
        _:
            return Vector2.DOWN