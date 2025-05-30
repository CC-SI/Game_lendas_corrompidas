extends KinematicBody2D

signal acertou_inimigo(inimigo) 

export var velocidade_x = 300
export var distancia_maxima = 400

var velocidade = Vector2.ZERO
var ladoSprite

onready var sprite = $Sprite
onready var area2d = $Area2D
onready var acertarNodeSom = get_node("../Som/Acertar")
onready var lancarNodeSom = get_node("../Som/Lancar")

var inimigos = DadosGlobais.LISTA_INIMIGOS
var posicao_inicial = Vector2.ZERO

func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	queue_free()

func _physics_process(_delta):
	move_and_slide(velocidade)
	
	var distancia_percorrida = global_position.distance_to(posicao_inicial)
	if (distancia_percorrida >= distancia_maxima):
		queue_free()

func atirarBola(lado):
	velocidade.x = velocidade_x * lado
	ladoSprite = lado
	mudarLadoSprite()
	posicao_inicial = global_position
	lancarNodeSom.play(0)

func mudarLadoSprite():
	sprite.flip_v = ladoSprite != 1
	sprite.position.x = abs(sprite.position.x) * ladoSprite

func _on_AcertouInimigo_body_entered(body):
	if body.name in inimigos:
		print("Acertou: ", body.name)
		emit_signal("acertou_inimigo", body)
		acertarNodeSom.play(0)
		queue_free()
