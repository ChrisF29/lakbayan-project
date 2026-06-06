extends CharacterBody2D

@export var left_limit: float = 80.0
@export var right_limit: float = 420.0

@export var patrol_speed: float = 120.0
@export var chase_speed: float = 70.0

# How close before guard stops moving
@export var stop_distance: float = 16.0

var direction: int = 1
var player_detected := false

@onready var player = get_parent().get_node("Player")

func _physics_process(delta):

    if player == null:
        return

    if player_detected:

        var distance_x = player.global_position.x - global_position.x

        if abs(distance_x) > stop_distance:

            if distance_x > 0:
                velocity.x = chase_speed
            else:
                velocity.x = -chase_speed

        else:

            velocity.x = 0

    else:

        velocity.x = patrol_speed * direction

        if global_position.x >= right_limit:

            direction = -1

        elif global_position.x <= left_limit:

            direction = 1

    move_and_slide()

    global_position.x = clamp(
        global_position.x,
        left_limit,
        right_limit
    )

func _on_detection_area_body_entered(body):

    if body.is_in_group("player"):

        player_detected = true

func _on_detection_area_body_exited(body):

    if body.is_in_group("player"):

        player_detected = false

func _on_catch_area_body_entered(body):

    if body.is_in_group("player"):

        player_caught()

func player_caught():

    var scene = get_tree().current_scene

    if scene != null and scene.has_method("player_caught"):

        scene.player_caught()
        return

    get_tree().reload_current_scene()