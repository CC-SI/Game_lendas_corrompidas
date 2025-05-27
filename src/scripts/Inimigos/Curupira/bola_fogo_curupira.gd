extends KinematicBody2D

export var velocidade = 300
var foi_lancada = false
var direcao = Vector2.ZERO
var direcao_alvo = Vector2.ZERO
var velocidade_final = Vector2.ZERO

onready var lancarASP = $Som/Lancar
onready var acertarASP = $Som/Acertar

func _physics_process(delta):
	if !foi_lancada:
		direcao_alvo = DadosGlobais.player.global_position
		look_at(direcao_alvo)
		return
	
	velocidade_final = direcao * velocidade
	move_and_slide(velocidade_final)

func lancar():
	foi_lancada = true
	direcao = (direcao_alvo - global_position).normalized()
	$DuracaoTimer.start(5)
	lancarASP.play(0)

func aplicar_dano(valor):
	var player = get_tree().get_nodes_in_group("player")
	if (player.size() > 0):
		player[0].levar_dano(valor)

func _on_Area2D_body_entered(body):
	if !foi_lancada:
		return
	
	if body.is_in_group("player"): 
		aplicar_dano(1)
		acertarASP.play(0)
		$Sprite.hide()
		yield(acertarASP, "finished")
		queue_free()

func _on_DuracaoTimer_timeout():
	queue_free()
