extends CanvasLayer

@onready var anim = $AnimationPlayer

func fade_in():

    anim.play("fade_in")

    await anim.animation_finished

func fade_out():

    anim.play("fade_out")

    await anim.animation_finished