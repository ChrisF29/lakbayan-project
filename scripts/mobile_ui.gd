extends CanvasLayer

@onready var pause_menu_button = $PauseMenuButton
@onready var resume_button = $GamePaused/ResumeButton
@onready var save_button = $GamePaused/SaveButton
@onready var quit_to_menu_button = $GamePaused/QuitToMenuButton
@onready var pause_overlay = $TransparentOverlay
@onready var game_paused_panel = $GamePaused
@onready var interact_button = $InteractButton

const PATINTERO_SCENE := "res://minigames/patintero.tscn"

var _patintero_mode = false

func _ready():

    _set_pause_ui_visible(false)

    if pause_menu_button:
        pause_menu_button.pressed.connect(_on_pause_button_pressed)

    if resume_button:
        resume_button.pressed.connect(_on_resume_button_pressed)

    if save_button:
        save_button.pressed.connect(_on_save_button_pressed)

    if quit_to_menu_button:
        quit_to_menu_button.pressed.connect(
            _on_quit_to_menu_pressed
        )

    if interact_button:
        interact_button.pressed.connect(
            _on_interact_button_pressed
        )

    _update_interact_mode_for_scene()

func _process(_delta):

    _update_interact_mode_for_scene()

func _unhandled_input(event):

    var is_escape = event is InputEventKey \
        and event.pressed \
        and !event.echo \
        and event.keycode == KEY_ESCAPE

    if event.is_action_pressed("ui_cancel") or is_escape:
        _toggle_pause_ui()
        get_viewport().set_input_as_handled()

func _on_pause_button_pressed():

    _toggle_pause_ui()

func _on_resume_button_pressed():

    _set_pause_ui_visible(false)

func _on_save_button_pressed():

    var saved = PlayerData.save_game()

    if saved:
        print("Game saved.")
    else:
        push_warning("Save failed.")

func _on_quit_to_menu_pressed():

    _set_pause_ui_visible(false)

    get_tree().change_scene_to_file(
        "res://scenes/main_menu.tscn"
    )

func _toggle_pause_ui():

    _set_pause_ui_visible(!game_paused_panel.visible)

func _set_pause_ui_visible(is_visible):

    pause_overlay.visible = is_visible
    game_paused_panel.visible = is_visible
    get_tree().paused = is_visible

func _update_interact_mode_for_scene():

    if interact_button == null:
        return

    var scene = get_tree().current_scene
    if scene == null:
        return

    var is_patintero = scene.scene_file_path == PATINTERO_SCENE

    if is_patintero == _patintero_mode:
        return

    _patintero_mode = is_patintero

    if _patintero_mode:
        if !InputMap.has_action("dash"):
            InputMap.add_action("dash")

        interact_button.visible = true
        interact_button.action = "dash"
    else:
        interact_button.action = "interact"
        interact_button.visible = false

func _on_interact_button_pressed():

    if !_patintero_mode:
        return

    var player = get_tree().get_first_node_in_group("player")

    if player != null and player.has_method("try_dash"):
        player.try_dash()
