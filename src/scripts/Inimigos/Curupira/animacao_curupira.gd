extends Node2D

onready var curupira = get_parent()

func _process(delta):
	$"../AnimationTree".set("parameters/bola_fogo/conditions/esta_parado", curupira.estado == "parado")
	$"../AnimationTree".set("parameters/cansado/conditions/esta_parado", curupira.estado == "parado")
	$"../AnimationTree".set("parameters/assobio/conditions/esta_cansado", curupira.estado == "descansando")
	$"../AnimationTree".set("parameters/conditions/assobio", curupira.estado == "assobiando")
	$"../AnimationTree".set("parameters/conditions/bola_fogo", curupira.estado == "bola_fogo")
	$"../AnimationTree".set("parameters/conditions/esta_cansado", curupira.estado == "descansando")
	$"../AnimationTree".set("parameters/conditions/soco", curupira.estado == "soco")
	$"../AnimationTree".set("parameters/conditions/esta_teletransportando", curupira.estado == "teletransportando")
	$"../AnimationTree".set("parameters/conditions/esta_morto", curupira.estado == "morto")

func aumentar_velocidade():
	$"../AnimationTree".set("parameters/bola_fogo/preparando_bola_fogo/TimeScale/scale", 2)
	$"../AnimationTree".set("parameters/bola_fogo/terminando_lançar_bola_fogo/TimeScale/scale", 2)
	$"../AnimationTree".set("parameters/soco/TimeScale/scale", 2)
	$"../AnimationTree".set("parameters/teletransportando/TimeScale/scale", 2)
	$"../AnimationTree".set("parameters/assobio/começando_assobiar/TimeScale/scale", 2)
	$"../AnimationTree".set("parameters/assobio/terminando_assobiar/TimeScale/scale", 2)
