extends KinematicBody2D

# -- CONFIGURAÇÕES --
export var velocidade = 400
export var gravidade = 50
export var forca_pulo = 700
export var force_dash = 1500
var bolaDeFogo = preload("res://src/Cenas/Player/BolaDeFogo.tscn")

# -- ESTADO --
var lado = 1
var pulos_restantes = 1
var direcao = Vector2.ZERO

# -- REFERÊNCIAS --
onready var camera = $Camera2D
onready var sprite = $Sprite
onready var area2d = $Mordida
onready var position2D = $Position2D

# -- CONTROLE DE INIMIGOS --
var inimigo_na_area = []
var inimigos_no_uivo = []
var inimigos = DadosGlobais.LISTA_INIMIGOS

# -- READY --
func _ready():
	DadosGlobais.vidas = 3
	camera.limit_top = 10
	camera.limit_bottom = get_viewport().size.y
	camera.limit_left = 0
	DadosGlobais.player = self

# -- PROCESSO PRINCIPAL --
func _process(delta):
	movePlayer()
	mudarLadoSprite()
	direcao = move_and_slide(direcao, Vector2.UP)

	verificar_mordida()
	usar_uivo()
	atirar_bola()
	morrer()


# MOVIMENTAÇÃO E CONTROLES 
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
		direcao.x = lado * force_dash

func mudarLadoSprite():
	sprite.flip_h = lado != 1
	area2d.scale.x = lado
	position2D.position.x = abs(position2D.position.x) * lado


# ATAQUES E HABILIDADES
func atirar_bola():
	if Input.is_action_just_pressed("atirar"):
		var bola = bolaDeFogo.instance()
		get_parent().add_child(bola)

		var offset = Vector2(40 * lado, 0)
		bola.global_position = position2D.global_position + offset
		var body_bola = bola.get_node("Bola de Fogo")

		body_bola.atirarBola(lado)
		body_bola.connect("acertou_inimigo", self, "_on_bola_acertou")
		
func verificar_mordida():
	if Input.is_action_just_pressed("mordida"):
		var isAcertou = false
		for inimigo in inimigo_na_area:
			inimigo.levar_dano(1)
			isAcertou = true
			break

func usar_uivo():
	if Input.is_action_just_pressed("uivo"):
		for inimigo in inimigos_no_uivo:
			inimigo.aplicar_lentidao(1)
		
#RECEBER E APLICAR DANO 
func _on_bola_acertou(inimigo):
	if inimigo.has_method("levar_dano"):
		inimigo.levar_dano(3)

func levar_dano(valor):
	DadosGlobais.vidas -= valor

func aplicar_lentidao(duracao):
	velocidade = 0
	yield(get_tree().create_timer(duracao), "timeout")
	velocidade = 400


#ÁREAS DE INTERAÇÃO
func _on_ZonaDeAtaque_body_entered(body):
	if body.name in inimigos:
		inimigo_na_area.append(body)
		
	

func _on_ZonaDeAtaque_body_exited(body):
	if body.name in inimigos:
		inimigo_na_area.erase(body)
		
func _on_Uivo_body_entered(body):
	if body is InimigoBase:
		inimigos_no_uivo.append(body)

func _on_Uivo_body_exited(body):
	if body is InimigoBase:
		inimigos_no_uivo.erase(body)


#GAME OVER 
func morrer():
	if DadosGlobais.vidas <= 0:
		for i in range(10, -1, -1):
			sprite.modulate.a = i / 10.0
			yield(get_tree().create_timer(0.05), "timeout")
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene("res://src/Cenas/GameOver.tscn")
