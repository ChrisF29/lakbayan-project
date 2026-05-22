extends CanvasLayer

@export var use_swirl := false
@export var swirl_intro := false
@export var transition_time := 1.0
@export var swirl_strength := 3.0
@export var fade_color := Color(0, 0, 0, 1)

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var rect: ColorRect = $ColorRect

var _material: ShaderMaterial
var _tween: Tween

const _SWIRL_SHADER := """
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float swirl_strength : hint_range(0.0, 8.0) = 3.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform vec4 fade_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 delta = uv - center;
    float dist = length(delta);
    float angle = swirl_strength * progress * (1.0 - smoothstep(0.0, 0.8, dist));
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(delta.x * c - delta.y * s, delta.x * s + delta.y * c);
    vec2 swirl_uv = center + rotated;

    vec4 screen_col = texture(screen_texture, swirl_uv);
    float alpha = smoothstep(0.0, 1.0, progress);
    COLOR = mix(screen_col, fade_color, alpha);
}
"""

func _ready() -> void:
    if swirl_intro:
        _ensure_material()
        _set_progress(1.0)
    else:
        _disable_swirl()

func fade_in() -> void:
    if swirl_intro:
        _ensure_material()
        _set_progress(1.0)
        _start_tween(0.0, transition_time)
        await _tween.finished
        if !use_swirl:
            _disable_swirl()
        return

    _disable_swirl()
    anim.play("fade_in")
    await anim.animation_finished

func fade_out() -> void:
    if use_swirl:
        _ensure_material()
        _set_progress(0.0)
        _start_tween(1.0, transition_time)
        await _tween.finished
        return

    _disable_swirl()
    anim.play("fade_out")
    await anim.animation_finished

func _ensure_material() -> void:
    if rect == null:
        return

    rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

    if _material == null:
        if rect.material is ShaderMaterial:
            _material = rect.material
        else:
            var shader := Shader.new()
            shader.code = _SWIRL_SHADER
            _material = ShaderMaterial.new()
            _material.shader = shader
    elif _material.shader == null:
        var shader := Shader.new()
        shader.code = _SWIRL_SHADER
        _material.shader = shader

    rect.material = _material

    _material.set_shader_parameter("swirl_strength", swirl_strength)
    _material.set_shader_parameter("fade_color", fade_color)

func _disable_swirl() -> void:
    if rect == null:
        return
    rect.material = null

func _start_tween(target: float, duration: float) -> void:
    if _tween != null:
        _tween.kill()

    _tween = create_tween()
    _tween.set_trans(Tween.TRANS_SINE)
    _tween.set_ease(Tween.EASE_IN_OUT)
    _tween.tween_property(_material, "shader_parameter/progress", target, duration)

func _set_progress(value: float) -> void:
    if _material == null:
        return
    _material.set_shader_parameter("progress", clamp(value, 0.0, 1.0))