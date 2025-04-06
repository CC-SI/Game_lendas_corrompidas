extends InimigoBase

export var intervalo_tiro = 1.5
export var bolaDeFogo = preload("res://src/Cenas/Inimigos/BlocoDeFogo.tscn")

var perseguindo = false
var alvo = null
var tempo_no_alvo = 0
var atirando = false

onready var timer_tiro = Timer.new()

func _ready():
	$Sprite.flip_h = true
	velocidade = 30
	add_child(timer_tiro)
	timer_tiro.wait_time = intervalo_tiro
	timer_tiro.connect("timeout", self, "_atirar")

func _process(delta):
	if (perseguindo and alvo and alvo.is_inside_tree()):
		tempo_no_alvo += delta
		if tempo_no_alvo >= 3.0 and not atirando:
			iniciar_ataque()
		
		if not atirando:
			var direcao = (alvo.global_position - global_position).normalized()
			direcao.y = 0
			move_and_slide(direcao * velocidade)
			$Sprite.flip_h = direcao.x < 0
			$Area2D.scale.x = -1 if direcao.x < 0 else 1

func _on_ZonaVisao_body_entered(body):
	if body.is_in_group("player"):
		perseguindo = true
		alvo = body
		tempo_no_alvo = 0
		print("Player está na visão do monstro")

func _on_ZonaVisao_body_exited(body):
	if body.is_in_group("player"):
		perseguindo = false
		alvo = null
		tempo_no_alvo = 0
		parar_ataque()
		print("Player saiu da visão do monstro")

func iniciar_ataque():
	atirando = true
	timer_tiro.start()
	print("Monstro começou a atirar!")

func parar_ataque():
	atirando = false
	timer_tiro.stop()
	print("Monstro parou de atirar.")

func _atirar():
	if not alvo: return
	
	var bola = bolaDeFogo.instance()
	get_parent().add_child(bola)
	bola.global_position = global_position
