extends InimigoBase

onready var sprite = $Sprite
onready var kickArea2D = $Chute

onready var posTop = $PositionTop
onready var posEsq = $PositionEsq
onready var posDir = $PositionDir

onready var timer = $Timer

onready var zona1 = $"Zona 1"
onready var zona2 = $"Zona 2"
onready var zona3 = $"Zona 3"

var playerList = []

var lado
var current_attacks: int
var isAssobioOpen: bool = false
var isOutZone: bool = true
var isAttacking = false
var last_attack = ""
var same_attack_count = 0
var can_attack = false

var isPostAssobio = false

func _ready():
	timer.start(10)
	disable_area2D()
	velocidade = 300

func _process(delta):
	follow_player()
	mudarLadoSprite()

	if not isAttacking and isOutZone and can_attack:
		decides_to_attack()

func decides_to_attack():
	var attack_choice = ""
	if last_attack == "tp":
		attack_choice = "bola_de_fogo"
	elif last_attack == "bola_de_fogo":
		attack_choice = "tp"
	else:
		attack_choice = "tp" if rand_range(0, 1) > 0.5 else "bola_de_fogo"
		
	if same_attack_count >= 2:
		attack_choice = "tp" if last_attack != "tp" else "bola_de_fogo"
		same_attack_count = 0
	
	if attack_choice == "tp":
		tp()
		print("Deu tp")
		current_attacks += 1
	elif attack_choice == "bola_de_fogo":
		_bola_de_fogo()
		print("bola de fogo")
		current_attacks += 1
	else:
		same_attack_count = 1
	last_attack = attack_choice

func tp():
	isAttacking = true
	tp_player()
	velocidade = 1
	yield(get_tree().create_timer(1), "timeout")
	velocidade = 300
	
	isAttacking = false
	can_attack = false
	timer.start(10) 

func _bola_de_fogo():
	var intervalBetweenBolls = rand_range(0.5, 1.2)
	var bolaDeFogoTop = preload("res://src/Cenas/Inimigos/Bolas de fogo/BolaDeFogoCurupira.tscn")
	var bolaDeFogoEsq = preload("res://src/Cenas/Inimigos/Bolas de fogo/BolaDeFogoEsq.tscn")
	var bolaDeFogoDir = preload("res://src/Cenas/Inimigos/Bolas de fogo/BolaDeFogoDir.tscn")
	
	isAttacking = true
	
	var bolaTop = bolaDeFogoTop.instance()
	get_parent().add_child(bolaTop)
	bolaTop.global_position = posTop.global_position
	yield(get_tree().create_timer(intervalBetweenBolls), "timeout")
	
	var bolaEsq = bolaDeFogoEsq.instance()
	get_parent().add_child(bolaEsq)
	bolaEsq.global_position = posEsq.global_position
	yield(get_tree().create_timer(intervalBetweenBolls), "timeout")
	
	var bolaDir = bolaDeFogoDir.instance()
	get_parent().add_child(bolaDir)
	bolaDir.global_position = posDir.global_position
	
	yield(get_tree().create_timer(1.0), "timeout")
	isAttacking = false
	can_attack = false
	timer.start(10) 

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		playerList.append(body)
		isOutZone = false
		print("Entrou")

func _on_Area2D_body_exited(body):
	if playerList.has(body):
		playerList.erase(body)
		isOutZone = true
		print("Saiu")

func _on_Chute_body_entered(body):
	if body.is_in_group("player"):
		current_attacks += 1
		aplicar_dano(1)

func mudarLadoSprite():
	sprite.flip_h = lado != 1
	kickArea2D.scale.x = lado

func _on_Timer_timeout():
	can_attack = true

func _on_Zona_1_body_entered(body):
	if body.is_in_group("player"):
		aplicar_dano(1)
		print("player encostou em mim")

func _on_Zona_2_body_entered(body):
	if body.is_in_group("player"):
		aplicar_dano(1)
		print("player encostou em mim")

func _on_Zona_3_body_entered(body):
	if body.is_in_group("player"):
		aplicar_dano(1)
		print("player encostou em mim")

func disable_area2D():
	zona1.visible = false
	zona1.monitoring = false
	zona1.set_process(false)

	zona2.visible = false
	zona2.monitoring = false
	zona2.set_process(false)

	zona3.visible = false
	zona3.monitoring = false
	zona3.set_process(false)
	
func enable_area2D():
	zona1.visible = true
	zona1.monitoring = true
	zona1.set_process(true)

	zona2.visible = true
	zona2.monitoring = true
	zona2.set_process(true)

	zona3.visible = true
	zona3.monitoring = true
	zona3.set_process(true)
