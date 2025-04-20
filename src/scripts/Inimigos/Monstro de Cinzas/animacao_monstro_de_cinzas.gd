extends Node2D

var monstro_de_cinzas = get_parent()

func _process(delta):
	$AnimationTree.set("parameters/movimentacao/blend_position", monstro_de_cinzas.direcao.x.normalized())
	
	$AnimationTree.set("parameters/conditions/esta_movimentando", !monstro_de_cinzas.atirando and !monstro_de_cinzas.esta_morto)
	$AnimationTree.set("parameters/conditions/esta_atacando", monstro_de_cinzas.atirando and !monstro_de_cinzas.esta_morto)
	$AnimationTree.set("parameters/conditions/esta_morto", monstro_de_cinzas.esta_morto)
