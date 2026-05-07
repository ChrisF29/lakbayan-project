extends Node

const DEFAULT_TRACK := preload("res://music/Adventure Begins  (16-Bit Arcade No Copyright Music).mp3")
const ALLOWED_SCENES := [
	"res://scenes/main_menu.tscn",
	"res://scenes/shop.tscn",
]

@onready var _player: AudioStreamPlayer = AudioStreamPlayer.new()
var _last_scene_path := ""

func _ready() -> void:
	add_child(_player)
	_player.bus = "Music"
	_player.stream = DEFAULT_TRACK
	_player.volume_db = -20.0

	_sync_scene_music()

	if not _player.playing:
		_player.play()

func play_music(stream: AudioStream) -> void:
	if _player.stream == stream and _player.playing:
		return

	_player.stream = stream
	_player.play()

func stop_music() -> void:
	_player.stop()

func _process(_delta: float) -> void:
	_sync_scene_music()

func _sync_scene_music() -> void:
	var current_scene := get_tree().current_scene
	if current_scene == null:
		return

	var scene_path := current_scene.scene_file_path
	if scene_path == "" or scene_path == _last_scene_path:
		return

	_last_scene_path = scene_path

	if _is_allowed_scene(scene_path):
		if not _player.playing:
			_player.play()
	else:
		if _player.playing:
			_player.stop()

func _is_allowed_scene(scene_path: String) -> bool:
	return ALLOWED_SCENES.has(scene_path)

func fade_out_music(duration := 1.0):

	var tween = create_tween()

	tween.tween_property(
		_player,
		"volume_db",
		-80,
		duration
	)

	await tween.finished

	_player.stop()

func fade_in_music(duration := 1.0):

	_player.volume_db = -80

	if !_player.playing:
		_player.play()

	var tween = create_tween()

	tween.tween_property(
		_player,
		"volume_db",
		-20,
		duration
	)