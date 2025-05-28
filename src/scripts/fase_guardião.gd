extends Node2D

onready var animacao = $Animacao/AnimationPlayer
onready var player = $Player/Player
onready var tayrin = $Player/Instancias/teste
onready var curupira = $Curupira/Curupira

var estado = "cutscene"

func _ready():
	curupira.connect("morte_curupira", self, "on_morte_curupira")
	$CanvasLayer.associar_fase(self)
	iniciar_cutscene("comeco_luta")

func iniciar_cutscene(cutscene):
	if cutscene == "termino_luta":
		tayrin.visible = false
	
	estado = "cutscene"
	player.cutscene = true
	curupira.cutscene = true
	animacao.play(cutscene)

func terminar_cutscene():
	estado = "gameplay"
	player.cutscene = false
	curupira.cutscene = false

func proxima_cena():
	get_tree().change_scene("res://src/Cenas/Final.tscn")

func on_morte_curupira():
	animacao.play("transicao_preta")
	yield(animacao, "animation_finished")
	$Som/BGM.stop()
	iniciar_cutscene("termino_luta")
