extends KinematicBody2D
class_name InimigoBase

export var vidas = 3
export var nome_do_inimigo = "Inimigo"
var velocidade = 100

func levar_dano(valor):
	vidas -= valor
	print("%s levou %d de dano!" % [nome_do_inimigo, valor])
	if vidas <= 0:
		morrer()
		
func aplicar_dano(valor):
	var player = get_tree().get_nodes_in_group("player")
	if (player.size() > 0):
		player[0].levar_dano(valor)
		print("%s causou %d de dano ao player!" % [nome_do_inimigo, valor])

func aplicar_lentidao(duracao):
	velocidade = 10
	yield(get_tree().create_timer(duracao), "timeout")
	velocidade = 100

func morrer():
	print("%s morreu!" % nome_do_inimigo)
	queue_free()
