extends Node2D

var morcego = get_parent()

func _process(delta):
	$AnimationTree.set("parameters/conditions/esta_voando", !morcego.esta_atacando and !morcego.esta_morto)
	$AnimationTree.set("parameters/conditions/esta_atacando", morcego.esta_atacando and !morcego.esta_morto)
	$AnimationTree.set("parameters/conditions/esta_morto", morcego.esta_morto)
