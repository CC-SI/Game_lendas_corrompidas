extends KinematicBody2D

"""
	O export serve para deixar as variaveis visiveis no Inspector
	ai podemos alterar o valor dela sem acessar o script
	
	Os ":" para definirmos o tipo da variavel
"""

export var velocidade: float = 450
export var forca_pulo: float = 1000
export var velocidade_queda: float = 30 

var direcao = Vector2.ZERO

# "onready" faz com que a variável seja inicializada apenas quando o nó estiver pronto.
# Isso evita erros caso tentemos acessar um nó que ainda não foi carregado no jogo.
onready var animationPlayer = $AnimationPlayer # Referência ao componente de animação
onready var spritePlayer = $Sprite # Referência ao sprite do personagem (para virar a imagem)

func _process(delta):
	direcao.x = 0
	direcao.y += velocidade_queda
		
	_move_slide() # chamando função 
	_move_jump() # chamando função 
	
	direcao = move_and_slide(direcao, Vector2.UP)

func _move_slide(): # Função de movimentação para os lados ( Esquerda / Direita )
	if Input.is_action_pressed("ui_left"): # Se a tecla de andar para a esquerda for pressionada...
		direcao.x = -velocidade # Move o personagem para a esquerda
		animationPlayer.play("andando") # Toca a animação de andar
		spritePlayer.flip_h = true # Vira o sprite para a esquerda
	elif Input.is_action_pressed("ui_right"): # Se a tecla de andar para a direita for pressionada...
		direcao.x = velocidade # Move o personagem para a direita
		animationPlayer.play("andando") # Toca a animação de andar
		spritePlayer.flip_h = false # Vira o sprite para a direita
	else:
		animationPlayer.play("parado") # Se nenhuma tecla for pressionada, toca a animação de parado
	
		
func _move_jump(): # Função de pulo
	if (Input.is_action_just_pressed("ui_accept") and is_on_floor()):
		direcao.y = -forca_pulo
		
