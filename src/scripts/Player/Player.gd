extends KinematicBody2D

# -- CONFIGURAÇÕES --
export var velocidade = 400
export var gravidade = 50
export var forca_pulo = 700
export var force_dash = 1500
var bolaDeFogo = preload("res://src/Cenas/Player/BolaDeFogo.tscn")

# -- ESTADO --
var estado_jogador = "padrao"
var lado = 1
var pulos_restantes = 1
var direcao = Vector2.ZERO
var esta_vuneravel = true

# -- REFERÊNCIAS --
onready var camera = $Camera2D
onready var sprite = $Sprite
onready var area2d = $Mordida
onready var position2D = $Position2D
onready var tayrin = $Tayrin

onready var uivo_cooldown = $UivoCooldown
onready var bola_fogo_cooldown = $BolaFogoCooldown
onready var dash_cooldown = $DashCooldown

# -- CONTROLE DE INIMIGOS --
var inimigo_na_area = []
var inimigos_no_uivo = []
var inimigos = DadosGlobais.LISTA_INIMIGOS
var input_ativo = true


# -- READY --
func _ready():
	DadosGlobais.vidas = 3
	camera.limit_top = 0
	#camera.limit_bottom = get_viewport().size.y
	camera.limit_left = 0
	DadosGlobais.player = self
	input_ativo = true

# -- PROCESSO PRINCIPAL --
func _physics_process(delta):
	if estado_jogador == "morto" or estado_jogador == "dano":
		return
	
	morrer()
	movePlayer()
	mudarLadoSprite()
	
	if estado_jogador != "padrao":
		direcao = move_and_slide(direcao, Vector2.UP)
		return
	
	dash()
	direcao = move_and_slide(direcao, Vector2.UP)
	verificar_mordida()
	usar_uivo()
	atirar_bola()


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

func dash():
	if !dash_cooldown.is_stopped():
		return
	
	if Input.is_action_just_pressed("dash"):
		estado_jogador = "dash"
		esta_vuneravel = false
		dash_cooldown.start()
		
		direcao.x = lado * force_dash

func mudarLadoSprite():
	sprite.flip_h = lado != 1
	sprite.position.x = abs(sprite.position.x) * -lado
	area2d.scale.x = lado
	position2D.position.x = abs(position2D.position.x) * lado
	tayrin.position.x = abs(tayrin.position.x) * -lado

func resetar_estado():
	estado_jogador = "padrao"
	esta_vuneravel = true

func renascer(posicao):
	global_position = posicao

func aumentar_vida(valor):
	if DadosGlobais.vidas >= 10: 
		return
	
	DadosGlobais.vidas += valor

# ATAQUES E HABILIDADES
func atirar_bola():
	if !bola_fogo_cooldown.is_stopped():
		return
	
	if Input.is_action_just_pressed("atirar"):
		bola_fogo_cooldown.start()
		
		var bola = bolaDeFogo.instance()
		get_parent().add_child(bola)

		var offset = Vector2(40 * lado, 0)
		bola.global_position = position2D.global_position + offset
		var body_bola = bola.get_node("Bola de Fogo")

		body_bola.atirarBola(lado)
		body_bola.connect("acertou_inimigo", self, "_on_bola_acertou")
		
func verificar_mordida():
	if Input.is_action_just_pressed("mordida"):
		estado_jogador = "mordida"
		esta_vuneravel = false
		var isAcertou = false
		for inimigo in inimigo_na_area:
			inimigo.levar_dano(1)
			isAcertou = true
			break

func usar_uivo():
	if !uivo_cooldown.is_stopped():
		return
	
	if Input.is_action_just_pressed("uivo"):
		estado_jogador = "uivo"
		esta_vuneravel = false
		uivo_cooldown.start()
		
		for inimigo in inimigos_no_uivo:
			var mudar_velocidade = 0
			
			if inimigo.nome_do_inimigo == "Morcego":
				aplicar_lentidao_morcego(inimigo, mudar_velocidade)
				
			inimigo.aplicar_lentidao(2)
		
#RECEBER E APLICAR DANO 
func _on_bola_acertou(inimigo):
	if inimigo.has_method("levar_dano"):
		inimigo.levar_dano(3)

func levar_dano(valor):
	if !esta_vuneravel:
		return
	
	estado_jogador = "dano"
	esta_vuneravel = false
	
	var material = sprite.material
	material.set_shader_param("flash", true)
	
	velocidade = 0
	DadosGlobais.vidas -= valor
	yield(get_tree().create_timer(0.25), "timeout")
	material.set_shader_param("flash", false)
	
	yield(get_tree().create_timer(0.25), "timeout")
	resetar_estado()
	velocidade = 400

func aplicar_lentidao(duracao):
	velocidade = 0
	yield(get_tree().create_timer(duracao), "timeout")
	velocidade = 400

func aplicar_lentidao_morcego(inimigo, mudar_velocidade):
	var velocidade_normal = inimigo.velocidade
	var velocidade_descendo = inimigo.velocidade_descendo
	var velocidade_subindo = inimigo.velocidade_subindo
				
	inimigo.velocidade = mudar_velocidade
	inimigo.velocidade_descendo = mudar_velocidade
	inimigo.velocidade_subindo = mudar_velocidade
				
	yield(get_tree().create_timer(2), "timeout")
				
	inimigo.velocidade = velocidade_normal
	inimigo.velocidade_descendo = velocidade_descendo
	inimigo.velocidade_subindo = velocidade_subindo

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
		input_ativo = false
		estado_jogador = "morto"
		esta_vuneravel = false
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().change_scene("res://src/Cenas/GameOver.tscn")
