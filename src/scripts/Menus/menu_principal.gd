extends Node2D

onready var camera = $Camera2D
onready var transicao = $Animacao/AnimationPlayer
onready var startASP = $Som/Iniciar
onready var sairASP = $Som/Sair

export var velocidade_camera = 100

func _ready():
	transicao.play_backwards("transicao_preta")

func _process(delta):
	camera.position.x += velocidade_camera * delta

func transicao_para_cutscene_introducao():
	transicao.play("transicao_preta")
	yield(transicao, "animation_finished")
	get_tree().change_scene("res://src/Cenas/Cutscene.tscn")

func sair_jogo():
	transicao.play("transicao_preta")
	yield(transicao, "animation_finished")
	get_tree().quit()

func _on_Botao_Jogar_pressed():
	if transicao.is_playing():
		return
	startASP.play(0)
	transicao_para_cutscene_introducao()

func _on_Botao_Sair_pressed():
	if transicao.is_playing():
		return
	sairASP.play(0)
	sair_jogo()
