extends KinematicBody2D

export var speed: float = 100
export var tempo_limite_parado: float = 1.5

onready var player = $"../Player"
onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var barraDeVida = $"Barra de vida"

var direction = Vector2.ZERO
var posicao_anterio = Vector2.ZERO
var tempo_preso = 0.0
var vidaMaxima: int = 10
var vidaAtual: int = 8

func _ready():
	barraDeVida.max_value = vidaMaxima
	barraDeVida.value = vidaAtual

func _process(delta):
	direction.x = (player.global_position.x - global_position.x)
	direction = direction.normalized()
	move_and_collide(Vector2(direction.x * speed * delta, 0))
	
	# Verifica a direção e ajusta o flip do sprite
	if (direction.x > 0):
		sprite.flip_h = false
	elif (direction.x < 0):
		sprite.flip_h = true
	
	# Verifica se o inimigo está parado comparando a posição anterior
	if (global_position.distance_to(posicao_anterio) < 1.0):
		tempo_preso += delta
	else:
		tempo_preso = 0.0
	
	# Ajusta a animação com base no tempo parado
	if (tempo_preso > tempo_limite_parado):
		animation.play("parado")  # Entra no idle se estiver parado há muito tempo
	elif direction.x != 0:
		animation.play("correndo")  # Continua andando se estiver se movendo

	# Atualiza a posição anterior para comparar na próxima verificação
	posicao_anterio = global_position
