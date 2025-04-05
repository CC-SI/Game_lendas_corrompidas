extends KinematicBody2D

var bolaDeFogo = preload("res://src/Cenas/BlocoDeFogo.tscn")

export var velocidade = 400
export var gravidade = 50
export var forca_pulo = 700
export var force_dash = 1500

var lado = 1
var pulos_restantes = 1
var direcao = Vector2.ZERO

onready var camera = $Camera2D
onready var sprite = $Sprite
onready var area2d = $Mordida
onready var position2D = $Position2D

var inimigo_na_area = []
var inimigos_no_uivo = []

var inimigos = ["Morcego", "MonstroDasCinzas"]

func _ready():
	DadosGlobais.vidas = 3
	$Camera2D.limit_top = 10
	$Camera2D.limit_bottom = get_viewport().size.y
	$Camera2D.limit_left = 0

func _process(delta):
	movePlayer()
	mudarLadoSprite()
	direcao = move_and_slide(direcao, Vector2.UP)
	verificar_mordida()
	morrer()
	usar_uivo()
	atirar()

func atirar():
	if Input.is_action_just_pressed("atirar"):
		var bola = bolaDeFogo.instance()
		get_parent().add_child(bola)
		bola.global_position = position2D.global_position
			
		

func levar_dano(valor):
	DadosGlobais.vidas -= valor
	print("Player levou ", valor, " de dano! Vidas restantes: ", DadosGlobais.vidas)

func aplicar_lentidao(duracao):
	velocidade = 100
	yield(get_tree().create_timer(duracao), "timeout")
	velocidade = 400

func movePlayer():
	direcao.x = 0
	direcao.y += gravidade

	if Input.is_action_pressed("ui_left"):
		direcao.x = -velocidade
		lado = -1
	elif Input.is_action_pressed("ui_right"):
		direcao.x = velocidade
		lado = 1

	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			direcao.y = -forca_pulo
			pulos_restantes = 1
		elif pulos_restantes > 0:
			direcao.y = -forca_pulo
			pulos_restantes -= 1

	if Input.is_action_just_pressed("dash"):
		if lado == 1:
			direcao.x = force_dash
		elif lado == -1:
			direcao.x = -force_dash

func _on_ZonaDeAtaque_body_entered(body):
	print("Entrou na zona: " + body.name)
	for nameInimigo in inimigos:
		if body.name == nameInimigo:
			inimigo_na_area.append(body)

func _on_ZonaDeAtaque_body_exited(body):
	print("Saiu da zona: " + body.name)
	for nameInimigo in inimigos:
		if body.name == nameInimigo:
			inimigo_na_area.erase(body)

func verificar_mordida():
	if Input.is_action_just_pressed("mordida"):
		var isAcertou = false
		for inimigo in inimigo_na_area:
			inimigo.levar_dano(1)
			print("Acertou: ", inimigo.nome_do_inimigo)
			isAcertou = true
			break
		if not isAcertou:
			print("Mordida aplicada, mas não atingiu ninguém")

func usar_uivo():
	if Input.is_action_just_pressed("uivo"):
		for inimigo in inimigos_no_uivo:
			inimigo.aplicar_lentidao(1)
		print("Uivo usado em %d inimigos!" % inimigos_no_uivo.size())

func _on_Uivo_body_entered(body):
	if body is InimigoBase:
		inimigos_no_uivo.append(body)

func _on_Uivo_body_exited(body):
	if body is InimigoBase:
		inimigos_no_uivo.erase(body)

func mudarLadoSprite():
	sprite.flip_h = lado != 1
	area2d.scale.x = lado

func morrer():
	if DadosGlobais.vidas <= 0:
		# Inicia o fade do sprite
		for i in range(10, -1, -1):
			sprite.modulate.a = i / 10.0  # Vai de 1.0 até 0.0 (transparente)
			yield(get_tree().create_timer(0.05), "timeout")  # Pequena pausa entre os fades

		# Espera um pouco após o fade
		yield(get_tree().create_timer(0.5), "timeout")

		get_tree().change_scene("res://src/Cenas/GameOver.tscn")

