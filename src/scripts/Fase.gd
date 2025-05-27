extends Node2D

onready var animacao = $Animacao/AnimationPlayer
onready var player = $Player/Player
onready var camera = $Camera2D
onready var saida = $"Ambiente/Entrada e Saída/Saída"

var estado = "gameplay"

export var proxima_cena = ""

func _ready():
	saida.connect("sair_fase", self, "on_sair_fase")
	$CanvasLayer.associar_fase(self)
	iniciar_cutscene("jogador_chegando")

func iniciar_cutscene(cutscene):
	estado = "cutscene"
	player.cutscene = true
	animacao.play(cutscene)

func terminar_cutscene():
	estado = "gameplay"
	player.cutscene = false
	camera.mudar_alvo(player)

func proxima_cena():
	estado = "cutscene"
	animacao.play("transicao_preta")
	yield(animacao, "animation_finished")
	get_tree().change_scene(proxima_cena)

func on_sair_fase():
	proxima_cena()
