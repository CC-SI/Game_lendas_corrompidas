extends Node2D

onready var monstro_de_cinzas = get_parent()

func _process(delta):
	var direcao = monstro_de_cinzas.direcao.normalized()
	
	$"../AnimationTree".set("parameters/movimentacao/blend_position", Vector2(direcao.x, 0))
	
	$"../AnimationTree".set("parameters/conditions/esta_movimentando", !monstro_de_cinzas.atirando and !monstro_de_cinzas.esta_morto)
	$"../AnimationTree".set("parameters/conditions/esta_atacando", monstro_de_cinzas.atirando and !monstro_de_cinzas.esta_morto)
	$"../AnimationTree".set("parameters/conditions/esta_morto", monstro_de_cinzas.esta_morto)
