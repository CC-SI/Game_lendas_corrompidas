extends InimigoBase

export var alcance_ataque = 10.0
export var tempo_re_ataque = 5.0
export var distancia_maxima = 100  
export var velocidade_descendo = 250
export var velocidade_subindo = 250

var alvo = null
var estado = "voando"
var posicao_y_inicial = 0.0
var posicao_x_inicial = 0.0
var direcao_horizontal = 1
var isPlayerEntryZone = false
var podeAtacar = true

onready var sprite = $Sprite
onready var atacou_player = $"Atacou Player"
onready var collider = $CollisionShape2D
onready var timer = Timer.new()

func _ready():
	estado = "voando"
	vidas = 1
	velocidade = 130
	posicao_x_inicial = global_position.x
	posicao_y_inicial = global_position.y
	add_child(timer)
	timer.wait_time = tempo_re_ataque
	timer.one_shot = true
	timer.connect("timeout", self, "_on_Timer_timeout")

func _process(delta):
	match estado:
		"voando":
			move_patrol(delta)
		"perseguindo":
			if alvo and podeAtacar:
				seguir_alvo(delta)
		"subindo":
			subir_para_posicao(delta)
		"esperando":
			move_patrol(delta)
		"morto":
			alvo = null
			return

	morreu()

func mudar_lado_sprite(lado):
	sprite.flip_h = lado < 0
	sprite.position.x = abs(sprite.position.x) * lado

func move_patrol(delta):
	global_position.x += direcao_horizontal * velocidade * delta

	var distancia_do_inicio = global_position.x - posicao_x_inicial

	if direcao_horizontal == 1 and distancia_do_inicio >= distancia_maxima:
		direcao_horizontal = -1
	elif direcao_horizontal == -1 and distancia_do_inicio <= -distancia_maxima:
		direcao_horizontal = 1
	
	mudar_lado_sprite(direcao_horizontal)

func seguir_alvo(delta):
	velocidade = velocidade_descendo
	var direcao = (alvo.global_position - global_position).normalized()
	global_position += direcao * velocidade * delta
	
	mudar_lado_sprite(direcao.x)

func subir_para_posicao(delta):
	velocidade = 130
	var diferenca_y = posicao_y_inicial - global_position.y

	if abs(diferenca_y) > 5:
		global_position.y += sign(diferenca_y) * velocidade_subindo * delta
	else:
		global_position.y = posicao_y_inicial
		estado = "esperando"
		podeAtacar = false
		timer.start()

func morreu():
	if vidas <= 0:
		var direcao = Vector2(0, 200)
		direcao = move_and_slide(direcao, Vector2.UP)
		estado = "morto"

func _on_Zona_de_Ataque_body_entered(body):
	if body.is_in_group("player"):
		alvo = body
		isPlayerEntryZone = true
		if podeAtacar:
			estado = "perseguindo"
		print("Player entrou na zona")

func _on_Zona_de_Ataque_body_exited(body):
	if body.is_in_group("player"):
		isPlayerEntryZone = false
		alvo = null
		if estado != "subindo" and estado != "descendo":
			estado = "voando"
		print("Player saiu da zona")

func _on_Encostou_Player_body_entered(body):
	if body.is_in_group("player") and podeAtacar:
		var player = DadosGlobais.player
		print("aplicou dano")

		aplicar_dano(1)

		estado = "subindo"

		

func _on_Timer_timeout():
	podeAtacar = true
	if isPlayerEntryZone and alvo:
		estado = "perseguindo"
	else:
		estado = "voando"
