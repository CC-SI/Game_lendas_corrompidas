extends Node2D

export var proxima_cena = ""

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene(proxima_cena)
