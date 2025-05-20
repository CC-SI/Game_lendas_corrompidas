extends Node2D

export var total_vida = 10  # Quantidade máxima de fragmentos
var vida = 0
onready var fragmentos = []
export var vida_jogador = true

func _ready():
	vida = total_vida
	
	for i in range(total_vida):
		var nome = "Fragmento%d" % i
		var fragmento = get_node(nome)
		fragmentos.append(fragmento)
	
	if vida_jogador:
		DadosGlobais.iniciarlizar_vida(total_vida)
	
	atualizar_barra()

func _process(delta):
	atualizar_barra()

func diminuir_vida(valor):
	vida -= valor

func atualizar_barra():
	for i in range(total_vida):
		if vida_jogador:
			fragmentos[i].visible = i < DadosGlobais.vidas
			continue
		
		fragmentos[i].visible = i < vida
