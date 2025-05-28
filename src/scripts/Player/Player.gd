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
var pulos_restantes = 2
var direcao = Vector2.ZERO
var esta_vuneravel = true
var cutscene = false

# -- SINAIS --
signal jogador_morto

# -- REFERÊNCIAS --
onready var sprite = $Sprite
onready var area2d = $Mordida
onready var position2D = $Position2D
var tayrin : Node2D
onready var instancias = get_node("../Instancias")
onready var quedaASP = $Sons/Queda

onready var uivo_cooldown = $UivoCooldown
onready var bola_fogo_cooldown = $BolaFogoCooldown
onready var dash_cooldown = $DashCooldown

onready var ui_comandos = $"../CanvasLayer/InformaçõesVisuais"

# -- CONTROLE DE INIMIGOS --
var inimigo_na_area = []
var inimigos_no_uivo = []
var inimigos = DadosGlobais.LISTA_INIMIGOS
var input_ativo = true

# -- READY --
func _ready():
	DadosGlobais.vidas = 3
	DadosGlobais.player = self
	input_ativo = true
	
	if !tayrin:
		tayrin = preload("res://src/Cenas/Tayrin/Tayrin.tscn").instance()
		tayrin.name = "teste"
		instancias.add_child(tayrin)
		tayrin = instancias.get_node("teste")
		
		tayrin.global_position = $Tayrin.global_position
		tayrin.seguir($Tayrin);

# -- PROCESSO PRINCIPAL --
func _physics_process(delta):
	direcao.x = 0
	direcao.y += gravidade
	
	if estado_jogador == "morto" or estado_jogador == "dano" or cutscene:
		ui_comandos.visible = false
		direcao = move_and_slide(direcao, Vector2.UP)
		return
	
	ui_comandos.visible = true
	
	morrer()
	
	if estado_jogador == "paralisado":
		return
	
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
	if Input.is_action_pressed("ui_left"):
		direcao.x = -velocidade
		lado = -1
	elif Input.is_action_pressed("ui_right"):
		direcao.x = velocidade
		lado = 1
	
	if is_on_floor():
		pulos_restantes = 2
	
	if Input.is_action_just_pressed("ui_accept"):
		if pulos_restantes > 0:
			direcao.y = -forca_pulo
			pulos_restantes -= 1

func dash():
	if !dash_cooldown.is_stopped():
		return
	
	if Input.is_action_just_pressed("dash"):
		estado_jogador = "dash"
		esta_vuneravel = false
		dash_cooldown.start()
		ui_comandos.exibir_cooldown_dash(true)
		criar_fantasma()
		direcao.x = lado * force_dash

func mudarLadoSprite():
	sprite.flip_h = lado != 1
	sprite.position.x = abs(sprite.position.x) * -lado
	area2d.scale.x = lado
	position2D.position.x = abs(position2D.position.x) * lado
	$Tayrin.position.x = abs($Tayrin.position.x) * -lado

func resetar_estado():
	estado_jogador = "padrao"
	esta_vuneravel = true

func renascer(posicao):
	global_position = posicao
	resetar_estado()

func aumentar_vida(valor):
	if DadosGlobais.vidas >= 10: 
		return
	
	$Sons/Vida.play(0)
	DadosGlobais.vidas += valor

# ATAQUES E HABILIDADES
func atirar_bola():
	if !bola_fogo_cooldown.is_stopped():
		return
	
	if Input.is_action_just_pressed("atirar"):
		bola_fogo_cooldown.start()
		ui_comandos.exibir_cooldown_fogo(true)
		
		var bola = bolaDeFogo.instance()
		get_parent().add_child(bola)

		var offset = Vector2(40 * lado, 0)
		bola.global_position = position2D.global_position + offset
		var body_bola = bola.get_node("Bola de Fogo")

		body_bola.atirarBola(lado)
		body_bola.connect("acertou_inimigo", self, "_on_bola_acertou")

func criar_fantasma():
	var offset_x = 0
	var intervalo = 0.5
	
	for i in range(3):
		fantasma(offset_x, intervalo)
		offset_x += 45
		intervalo += 0.25

func fantasma(var offset_x, var intervalo):
	var fantasma = sprite.duplicate()
	
	get_parent().add_child(fantasma)
	fantasma.global_position = global_position + Vector2(offset_x * lado, 0)
	
	fantasma.modulate = Color(0, 0, 0, 1)
	
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(fantasma, "self_modulate", Color(0, 0, 0, 0), intervalo)
	yield(tween_fade, "finished")
	
	fantasma.queue_free()

func paralisar(var valor_dano):
	estado_jogador = "paralisado"
	DadosGlobais.vidas -= valor_dano

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
		ui_comandos.exibir_cooldown_uivo(true)
		
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
		yield(get_tree().create_timer(1), "timeout")
		emit_signal("jogador_morto")

func somQueda():
	quedaASP.play(0)
