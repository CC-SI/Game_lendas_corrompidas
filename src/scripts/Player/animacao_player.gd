extends Node2D

onready var player = get_parent()

func _process(delta):
	var direcao = player.direcao.normalized()
	$"../AnimationTree".set("parameters/movimentacao/blend_position", Vector2(direcao.x if player.is_on_floor() else 0, -1 if !player.is_on_floor() and direcao.y == 0 else direcao.y))
	
	$"../AnimationTree".set("parameters/conditions/dash", player.estado_jogador == "dash")
	$"../AnimationTree".set("parameters/conditions/esta_mordendo", player.estado_jogador == "mordida")
	$"../AnimationTree".set("parameters/conditions/esta_uivando", player.estado_jogador == "uivo")
	$"../AnimationTree".set("parameters/conditions/esta_morto", player.estado_jogador == "morto")
