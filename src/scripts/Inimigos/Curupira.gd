extends KinematicBody2D

onready var sprite = $Sprite
onready var area_soco = $Soco
onready var area_decisao = $ZonaDecisao

onready var posicoes_bola_fogo = [
	$PositionTop,
	$PositionEsq,
	$PositionDir
]

var bolas_fogo = []
var bolas_fogo_restantes = []

onready var bgm = $BGM

var gravidade = 800

var playerList = []

var lado

#estados
var estado = "parado"
var pode_atacar = false
var escudo_ativo = false
var bravo = false
var ataques_realizados: int
var isOutZone: bool = true
var attack_choice = ""

#intervalos de tempo
var intervalo_ataque = 1.75
var intervalo_bola_fogo = 1.25
var intervalo_assobio = 2

export var vidas = 20

var contagem_ondas_sonoras = 0

func _ready():
	iniciar_timer_ataque()
	bgm.play(0);

func _physics_process(delta):
	var direcao = Vector2.ZERO
	direcao.y += gravidade
	
	direcao = move_and_slide(direcao, Vector2.UP)
	
	if estado == "morto":
		return
	
	var position_target = DadosGlobais.player.global_position
	lado = 1 if global_position.x < position_target.x else -1
	mudarLadoSprite()
	
	if estado == "descansando":
		ativar_defesa(false)
	else:
		ativar_defesa(true)
	
	if estado == "parado" and pode_atacar:
		decides_to_attack()

func decides_to_attack():
	if ataques_realizados >= (5 if bravo else 3):
		estado = "assobiando"
		ataques_realizados = 0
		return
	
	pode_atacar = false
	ataques_realizados += 1
	
	attack_choice = "soco" if rand_range(0, 1) > 0.5 else "bola_fogo"
	
	if !isOutZone:
		atacar()
		return
	
	tp()

func iniciar_timer_ataque():
	$AtaqueTimer.start(intervalo_ataque)

func atacar():
	estado = attack_choice

func ativar_defesa(isActive):
	escudo_ativo = isActive

func levar_dano(valor):
	if escudo_ativo:
		if $Escudo/AnimationPlayer.is_playing():
			$Escudo/AnimationPlayer.stop()
		$Escudo/AnimationPlayer.play("escudo_ativando")
		return
	
	var material = $Sprite.material
	material.set_shader_param("flash", true)
	yield(get_tree().create_timer(0.25), "timeout")
	material.set_shader_param("flash", false)
	
	vidas -= valor
	$BarraVidaCurupira.diminuir_vida(valor)
	
	if vidas <= 10:
		bravo = true
	
	if vidas <= 0:
		morrer()

func tp_player():
	var position_target = DadosGlobais.player.global_position
	var direction = 1 if global_position.x < position_target.x else -1
	var teleport_position = position_target + Vector2(60 * direction, 0)
	global_position = teleport_position

func aplicar_dano(valor):
	var player = get_tree().get_nodes_in_group("player")
	if (player.size() > 0):
		player[0].levar_dano(valor)

func resetar_estado():
	estado = "parado"
	
	if bravo:
		modo_bravo()

func modo_bravo():
	$AnimacaoCurupira.aumentar_velocidade()
	intervalo_ataque = 1
	intervalo_assobio = 1.4
	intervalo_bola_fogo = 0.5

func descansar():
	$DescansoTimer.start(6)

func assobiar():
	criar_onda_sonora()
	$AssobioTimer.start(intervalo_assobio)

func criar_onda_sonora():
	contagem_ondas_sonoras += 1
	var onda_sonora = preload("res://src/Cenas/Inimigos/Curupira/OndaSonora.tscn").instance()
	get_parent().add_child(onda_sonora)
	onda_sonora.global_position = $PosicaoAssobio.global_position

func tp():
	estado = "teletransportando"

func criar_bolas_fogo():
	bolas_fogo.clear()
	for posicao in posicoes_bola_fogo:
		var bola_fogo = preload("res://src/Cenas/Inimigos/Bolas de fogo/BolaDeFogoCurupira.tscn").instance()
		get_parent().add_child(bola_fogo)
		bola_fogo.global_position = posicao.global_position
		bolas_fogo.append(bola_fogo)

func iniciar_lancamento_bola_fogo():
	bolas_fogo_restantes.clear()
	bolas_fogo_restantes = bolas_fogo.duplicate()
	lancar_bola_fogo()
	$BolaFogoTimer.start(intervalo_bola_fogo)

func lancar_bola_fogo():
	var bola_fogo = bolas_fogo_restantes.pop_front()
	bola_fogo.lancar()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		playerList.append(body)
		isOutZone = false

func _on_Area2D_body_exited(body):
	if playerList.has(body):
		playerList.erase(body)
		isOutZone = true

func _on_Chute_body_entered(body):
	if body.is_in_group("player"):
		ataques_realizados += 1
		aplicar_dano(2)

func mudarLadoSprite():
	sprite.flip_h = lado != 1
	area_soco.scale.x = lado
	$PosicaoAssobio.position.x = abs($PosicaoAssobio.position.x) * lado

func _on_Timer_timeout():
	pode_atacar = true

func morrer():
	estado = "morto"
	bgm.stop();

func _on_AssobioTimer_timeout():
	if contagem_ondas_sonoras >= 3:
		contagem_ondas_sonoras = 0
		$AssobioTimer.stop()
		estado = "descansando"
		return
	
	criar_onda_sonora()

func _on_DescansoTimer_timeout():
	resetar_estado()

func _on_BolaFogoTimer_timeout():
	if bolas_fogo_restantes.empty():
		$BolaFogoTimer.stop()
		resetar_estado()
		return
	
	lancar_bola_fogo()
