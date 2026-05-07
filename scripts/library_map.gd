extends Node2D

@onready var fade = $FadeLayer
@onready var player = $Player

func _ready():

    player.can_move = false

    start_scene()
	
func start_scene():

    await fade.fade_in()

    player.can_move = true
