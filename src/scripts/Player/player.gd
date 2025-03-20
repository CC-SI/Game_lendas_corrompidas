extends KinematicBody2D

"""
	O export serve para deixar as variaveis visiveis no Inspector
	ai podemos alterar o valor dela sem acessar o script
	
	Os ":" para definirmos o tipo da variavel
"""

export var velocidade: float = 450
export var forca_pulo: float = 1000
export var velocidade_queda: float = 30 
export var dashForce = 1000
export var tempoDash: float = 1.0  # Tempo de cooldown do dash (em segundos)

onready var animationPlayer = $AnimationPlayer
onready var spritePlayer = $Sprite
onready var barraDeVida = $"Barra de vida"

var direcao = Vector2.ZERO
var ladoPersonagem = 1
var tempoDesdeUltimoDash: float = 0  # Controla o tempo desde o último dash
var vidaMaxima: int = 10
var vidaAtual: int = 10

func _ready():
	barraDeVida.max_value = vidaMaxima
	barraDeVida.value = vidaAtual

func _process(delta):
	direcao.x = 0
	direcao.y += velocidade_queda
	
	_move_slide()  # Movimentação para os lados
	_move_jump()   # Função de pulo
	dash(delta)    # Chamando função dash
	direcao = move_and_slide(direcao, Vector2.UP)

func _move_slide(): # Função de movimentação para os lados ( Esquerda / Direita )
	if Input.is_action_pressed("ui_left"): # Se a tecla de andar para a esquerda for pressionada...
		direcao.x = -velocidade # Move o personagem para a esquerda
		animationPlayer.play("andando") # Toca a animação de andar
		spritePlayer.flip_h = true # Vira o sprite para a esquerda
		ladoPersonagem = -1
	elif Input.is_action_pressed("ui_right"): # Se a tecla de andar para a direita for pressionada...
		direcao.x = velocidade # Move o personagem para a direita
		animationPlayer.play("andando") # Toca a animação de andar
		spritePlayer.flip_h = false # Vira o sprite para a direita
		ladoPersonagem = 1
	else:
		animationPlayer.play("parado") # Se nenhuma tecla for pressionada, toca a animação de parado
	
		
func _move_jump(): # Função de pulo
	if (Input.is_action_just_pressed("ui_accept") and is_on_floor()):
		direcao.y = -forca_pulo

func dash(delta):
	# Verificar se o dash pode ser realizado (cooldown)
	if Input.is_action_just_pressed("dash") and tempoDesdeUltimoDash >= tempoDash:
		if ladoPersonagem == -1:
			direcao.x = -dashForce
		elif ladoPersonagem == 1:
			direcao.x = dashForce
		
		# Resetar o tempo do cooldown
		tempoDesdeUltimoDash = 0

	# Atualizar o tempo desde o último dash
	tempoDesdeUltimoDash += delta
