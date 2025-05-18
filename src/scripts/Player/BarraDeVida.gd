extends Control

export var total_vida = 10  # Quantidade máxima de fragmentos
onready var fragmentos = []

func _ready():
	for i in range(total_vida):
		var nome = "Fragmento%d" % i
		var fragmento = get_node(nome)
		fragmentos.append(fragmento)
	
	DadosGlobais.iniciarlizar_vida()
	
	atualizar_barra()

func _process(delta):
	atualizar_barra()

func atualizar_barra():
	for i in range(total_vida):
		fragmentos[i].visible = i < DadosGlobais.vidas
