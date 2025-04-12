extends InimigoBase

export var alcance_ataque = 10.0
export var tempo_re_ataque = 5.0
export var distancia_maxima = 100  
export var velocidade_descendo = 200
export var velocidade_subindo = 250

var alvo = null
var estado = "voando"
var player_na_zona = false
var posicao_inicial = Vector2.ZERO
var tempo = 0.0
var direcao_voo = 1 

onready var sprite = $Sprite
onready var timer = Timer.new()

func _ready():
	posicao_inicial = global_position
	add_child(timer)
	timer.wait_time = tempo_re_ataque
	timer.one_shot = true
	timer.connect("timeout", self, "_on_Timer_timeout")

func _process(delta):
	tempo += delta

	match estado:
		"voando":
			var deslocamento_vertical = sin(tempo * 2.0) * 10
			var deslocamento_horizontal = direcao_voo * velocidade * delta
			global_position.x += deslocamento_horizontal
			global_position.y = posicao_inicial.y + deslocamento_vertical
			
			if abs(global_position.x - posicao_inicial.x) > distancia_maxima:
				direcao_voo *= -1
				sprite.flip_h = direcao_voo < 0

		"descendo":
			if alvo and alvo.is_inside_tree():
				var direcao_para_alvo = alvo.global_position - global_position
				if direcao_para_alvo.length() <= alcance_ataque:
					estado = "voltando"
					alvo = null
					print("Bateu no player e está voltando!")
				else:
					move_and_slide(direcao_para_alvo.normalized() * velocidade_descendo)
					sprite.flip_h = direcao_para_alvo.x < 0
			else:
				estado = "voltando"

		"voltando":
			var direcao_volta = posicao_inicial - global_position
			if direcao_volta.length() > 2:
				move_and_slide(direcao_volta.normalized() * velocidade_subindo)
				sprite.flip_h = direcao_volta.x < 0
			else:
				global_position = posicao_inicial
				estado = "voando"
				tempo = 0
				print("Morcego voltou para posição inicial.")
				if player_na_zona:
					timer.start()


func _on_Zona_de_Ataque_body_entered(body):
	if body.is_in_group("player"):
		player_na_zona = true
		if estado == "voando":
			alvo = body
			estado = "descendo"
			print("Player entrou na zona, morcego descendo!")

func _on_Zona_de_Ataque_body_exited(body):
	if body.is_in_group("player"):
		player_na_zona = false
		if estado == "descendo":
			alvo = null
			estado = "voltando"
			print("Player saiu da zona, morcego voltando!")
		timer.stop()

func _on_Encostou_Player_body_entered(body):
	if body.is_in_group("player"):
		aplicar_dano(1)
		
		if (body.has_method("aplicar_lentidao")):
			body.aplicar_lentidao(1.0)
		
		alvo = null
		estado = "voltando"
		print("Encostou no player! Voltando para a posição inicial.")

func _on_Timer_timeout():
	if player_na_zona and estado == "voando":
		alvo = get_tree().get_nodes_in_group("player")[0]
		estado = "descendo"
		print("Morcego atacando novamente após 5s.")

func morrer():
	print("Morcego morreu, fez barulho de morte!")
	queue_free()
