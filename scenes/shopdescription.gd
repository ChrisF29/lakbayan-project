extends Control

@onready var title = $GameTitle
var full_text := "Ang Kampilan ay isa sa mga pinakatanyag na sandata ng mga sinaunang Pilipino bago dumating ang mga Espanyol. Isa itong mahabang espada na karaniwang ginagamit ng mga mandirigma mula sa mga pangkat etniko sa Mindanao, kabilang ang mga Maranao, Maguindanao, at Tausug."

func _ready() -> void:
	title.visible = true
	title.modulate.a = 1.0

	await _reveal_letters()

func _reveal_letters():
	title.bbcode_enabled = false
	title.text = ""

	for i in range(full_text.length() + 1):
		title.text = full_text.substr(0, i)
		await get_tree().create_timer(0.12).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
