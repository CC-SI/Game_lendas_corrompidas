extends KinematicBody2D

var velocidade = 450
var direcao = Vector2.ZERO
var forca_pulo = 1000
var velocidade_queda = 30 

func _process(delta):
	direcao.x = 0
	direcao.y += velocidade_queda
	
	if (Input.is_action_pressed("ui_left")):
		direcao.x = -velocidade
	elif (Input.is_action_pressed("ui_right")):
		direcao.x = velocidade
		
	if (Input.is_action_just_pressed("ui_up") and is_on_floor()):
		direcao.y = -forca_pulo
	
	direcao = move_and_slide(direcao, Vector2(0,-1))
