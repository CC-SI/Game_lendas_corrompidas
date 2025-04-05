extends Node
class_name InimigoBase

export var vidas = 3
export var nome_do_inimigo = "Inimigo"

func levar_dano(valor):
	vidas -= valor
	print("%s levou %d de dano!" % [nome_do_inimigo, valor])
	if vidas <= 0:
		morrer()

func morrer():
	print("%s morreu!" % nome_do_inimigo)
	queue_free()
