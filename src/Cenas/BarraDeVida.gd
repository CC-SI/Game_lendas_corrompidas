extends Node2D

var barraDeVida = ""

func _ready():
	DadosGlobais.iniciarlizar_vida()
	
func _process(delta):
	barraDeVida = ""
	for i in range(DadosGlobais.vidas):
		barraDeVida += "| "
	print(barraDeVida)
	$Vida.text = barraDeVida
	
