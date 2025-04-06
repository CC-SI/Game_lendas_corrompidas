extends KinematicBody2D

signal acertou_inimigo(inimigo)  # Emite o node do inimigo

export var velocidade_x = 300
export var distancia_maxima = 400

var velocidade = Vector2.ZERO
var ladoSprite

onready var sprite = $Sprite
onready var area2d = $Area2D

var inimigos = DadosGlobais.LISTA_INIMIGOS
var posicao_inicial = Vector2.ZERO

func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()

func _process(delta):
	move_and_slide(velocidade)
	
	var distancia_percorrida = global_position.distance_to(posicao_inicial)
	if (distancia_percorrida >= distancia_maxima):
		queue_free()

func atirarBola(lado):
	velocidade.x = velocidade_x * lado
	ladoSprite = lado
	mudarLadoSprite()
	posicao_inicial = global_position

func mudarLadoSprite():
	sprite.flip_v = ladoSprite != 1
	area2d.scale.y = ladoSprite

func _on_AcertouInimigo_body_entered(body):
	if body.name in inimigos:
		print("Acertou: ", body.name)
		emit_signal("acertou_inimigo", body) 
		queue_free()
