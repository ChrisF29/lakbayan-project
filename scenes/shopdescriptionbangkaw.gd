extends Control

@onready var title = $GameTitle
var full_text := "Ang Bangkaw, o sibat, ay isa sa mga pinakamatanda at pinakakaraniwang sandata ng mga sinaunang Pilipino bago dumating ang mga Espanyol. Ginagamit ito hindi lamang sa pakikidigma kundi pati na rin sa pangangaso at pagtatanggol ng barangay."

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
