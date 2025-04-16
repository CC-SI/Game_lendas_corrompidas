extends KinematicBody2D

class_name BolaDeFogoBase

export var aceleracao = 550
export var distancia_maxima = 1500
export var tempo_parado_max = 2.0

var direcao: Vector2 = Vector2.LEFT
var velocidade = Vector2.ZERO
var posicao_inicial: Vector2

var ultima_posicao: Vector2
var tempo_parado = 0.0

func _ready():
	posicao_inicial = global_position

func _process(delta):
	velocidade = direcao.normalized() * aceleracao
	move_and_slide(velocidade)
	
	var distancia_percorrida = global_position.distance_to(posicao_inicial)
	if distancia_percorrida >= distancia_maxima:
		queue_free()
	
	if global_position.distance_to(ultima_posicao) < 1.0:
		tempo_parado += delta
		if tempo_parado >= tempo_parado_max:
			queue_free()
	else:
		tempo_parado = 0.0
	
	ultima_posicao = global_position
