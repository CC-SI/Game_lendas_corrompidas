extends InimigoBase

var zona1 = []
var zona2 = []
var zona3 = []

var fase_ataque = 0
var ataque_timer = null
var fase_timer = null

func _ready():
	# Timer para iniciar ataque a cada 15s
	ataque_timer = Timer.new()
	ataque_timer.wait_time = 2
	ataque_timer.one_shot = false
	ataque_timer.connect("timeout", self, "_on_AtaqueTimer_timeout")
	add_child(ataque_timer)
	ataque_timer.start()

	# Timer para avançar entre as zonas
	fase_timer = Timer.new()
	fase_timer.wait_time = 1.5
	fase_timer.one_shot = true
	fase_timer.connect("timeout", self, "_on_FaseTimer_timeout")
	add_child(fase_timer)

func _on_AtaqueTimer_timeout():
	# Inicia o ataque se tiver jogador em qualquer zona
	if zona1.size() > 0 or zona2.size() > 0 or zona3.size() > 0:
		fase_ataque = 1
		executar_fase_ataque()

func executar_fase_ataque():
	match fase_ataque:
		1:
			if zona1.size() > 0:
				for body in zona1:
					aplicar_dano(3)
					print("Ataque zona1 - Dano: 30 em " + body.name)
		2:
			if zona2.size() > 0:
				for body in zona2:
					aplicar_dano(2)
					print("Ataque zona2 - Dano: 20 em " + body.name)
		3:
			if zona3.size() > 0:
				for body in zona3:
					aplicar_dano(1)
					print("Ataque zona3 - Dano: 10 em " + body.name)
		_:
			return

	fase_ataque += 1
	if fase_ataque <= 3:
		fase_timer.start()

func _on_FaseTimer_timeout():
	executar_fase_ataque()

# ---------------------------------------
# Gerenciamento das zonas

func add_list(body, list: Array, nome_zona: String):
	if body.is_in_group("player"):
		if not list.has(body):
			list.append(body)
			print("Entrou na " + nome_zona + ": " + body.name)

func remove_list(body, list: Array, nome_zona: String):
	if list.has(body):
		list.erase(body)
		print("Saiu da " + nome_zona + ": " + body.name)

func _on_Onda_1_body_entered(body): add_list(body, zona1, "Zona 1")
func _on_Onda_1_body_exited(body): remove_list(body, zona1, "Zona 1")

func _on_Onda_2_body_entered(body): add_list(body, zona2, "Zona 2")
func _on_Onda_2_body_exited(body): remove_list(body, zona2, "Zona 2")

func _on_Onda_3_body_entered(body): add_list(body, zona3, "Zona 3")
func _on_Onda_3_body_exited(body): remove_list(body, zona3, "Zona 3")
