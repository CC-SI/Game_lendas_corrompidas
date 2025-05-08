extends Node2D

onready var morcego = get_parent()

func _process(delta):
	$"../AnimationTree".set("parameters/conditions/esta_voando", morcego.estado != "perseguindo" and !morcego.esta_morto)
	$"../AnimationTree".set("parameters/conditions/esta_atacando", morcego.estado == "perseguindo" and !morcego.esta_morto)
	$"../AnimationTree".set("parameters/conditions/esta_morto", morcego.esta_morto)
