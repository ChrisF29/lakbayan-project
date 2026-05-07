extends CharacterBody2D

@export var speed = 200

@onready var sprite = $AnimatedSprite2D
var facing = "front"
var can_move = true
var follow_target = null

func _physics_process(delta):

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