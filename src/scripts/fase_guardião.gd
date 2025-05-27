extends Node2D

onready var animacao = $Animacao/AnimationPlayer
onready var player = $Player/Player
onready var curupira = $Curupira/Curupira

var estado = "cutscene"

func _ready():
	$CanvasLayer.associar_fase(self)
	iniciar_cutscene("comeco_luta")

func iniciar_cutscene(cutscene):
	estado = "cutscene"
	player.cutscene = true
	curupira.cutscene = true
	animacao.play(cutscene)

func terminar_cutscene():
	estado = "gameplay"
	player.cutscene = false
	curupira.cutscene = false
