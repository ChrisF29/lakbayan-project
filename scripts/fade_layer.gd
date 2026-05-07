extends CanvasLayer

@onready var anim = $AnimationPlayer

func fade_out():

    anim.play("fade_out")

    await anim.animation_finished