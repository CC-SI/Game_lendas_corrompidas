extends Node2D

var player = get_parent()

func _process(delta):
	$AnimationTree.set("parameters/movimentacao/blend_position", player.direcao.normalized())
	
	$AnimationTree.set("parameters/conditions/dash", player.estado_jogador == "dash")
	$AnimationTree.set("parameters/conditions/esta_mordendo", player.estado_jogador == "mordida")
	$AnimationTree.set("parameters/conditions/esta_uivando", player.estado_jogador == "uivo")
	$AnimationTree.set("parameters/conditions/esta_morto", player.estado_jogador == "morto")
