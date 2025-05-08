extends InimigoBase

export var intervalo_tiro = 1.5
export var blocoDeFogo = preload("res://src/Cenas/Inimigos/BlocoDeFogo.tscn")

var perseguindo = false
var alvo = null
var tempo_no_alvo = 0
var atirando = false
var ataque_realizado = false 

onready var timer_tiro = Timer.new()
onready var timer_ataque = Timer.new()
onready var alvo_blocos_esq = $"Alvo dos blocos Esquerdo"
onready var alvo_blocos_dor = $"Alvo dos blocos Direita"

func _ready():
	velocidade = 30

	add_child(timer_tiro)
	timer_tiro.wait_time = intervalo_tiro
	timer_tiro.connect("timeout", self, "_atirar")

	add_child(timer_ataque)
	timer_ataque.wait_time = 3.0
	timer_ataque.one_shot = true
	timer_ataque.connect("timeout", self, "_fim_do_ataque")

func _process(delta):
	if perseguindo and alvo and alvo.is_inside_tree():
		tempo_no_alvo += delta
		
		direcao.y += gravidade 
		
		direcao = move_and_slide(direcao, Vector2.UP)
		
		# Ataca uma única vez após 3s
		if tempo_no_alvo >= 3.0 and not atirando and not ataque_realizado:
			iniciar_ataque()

		if not atirando:
			direcao = (alvo.global_position - global_position).normalized()
			
			move_and_slide(direcao * velocidade)
			$Sprite.flip_h = direcao.x > 0
			$Sprite.position.x = abs($Sprite.position.x) * direcao.x
			$Position2D.position.x = abs($Position2D.position.x) * -direcao.x

func _on_ZonaVisao_body_entered(body):
	if body.is_in_group("player"):
		perseguindo = true
		alvo = body
		tempo_no_alvo = 0

func _on_ZonaVisao_body_exited(body):
	if body.is_in_group("player"):
		perseguindo = false
		alvo = null
		tempo_no_alvo = 0
		parar_ataque()

func iniciar_ataque():
	atirando = true
	ataque_realizado = true 
	timer_tiro.start()
	timer_ataque.start()

func parar_ataque():
	atirando = false
	timer_tiro.stop()
	yield(get_tree().create_timer(5), "timeout")
	ataque_realizado = false

func _fim_do_ataque():
	parar_ataque()

func _atirar():
	if not alvo:
		return

	var quantidade = 6
	var angulo_inicial = -0.8  
	var angulo_final = 1.2
	var direcao_base = Vector2.UP

	for i in range(quantidade):
		var t = float(i) / (quantidade - 1)
		var angulo = lerp(angulo_inicial, angulo_final, t)
		var nova_direcao = direcao_base.rotated(angulo)
		
		var bola = blocoDeFogo.instance()
		get_parent().add_child(bola)
		
		if i < quantidade / 2:
			bola.global_position = alvo_blocos_esq.global_position
		else:
			bola.global_position = alvo_blocos_dor.global_position
			
	yield(get_tree().create_timer(4), "timeout")
		
