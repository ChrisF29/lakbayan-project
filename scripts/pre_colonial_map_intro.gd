extends Node2D

@onready var fade = $FadeLayer
@onready var player = $Player

func _ready() -> void:
    player.can_move = false
    await fade.fade_in()
    player.can_move = true
