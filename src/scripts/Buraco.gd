extends Node2D

onready var posicao_renascer = $Position2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		aplicar_dano(1)
		yield(get_tree().create_timer(1), "timeout")
		renascer_player(posicao_renascer.global_position)

func aplicar_dano(valor):
	var player = get_tree().get_nodes_in_group("player")
	if (player.size() > 0):
		player[0].paralisar(valor)

func renascer_player(posicao):
	var player = get_tree().get_nodes_in_group("player")
	if (player.size() > 0):
		if player[0].estado_jogador == "morto":
			return
		player[0].renascer(posicao)
