extends Node2D

onready var animacao = $AnimationPlayer
onready var caminho_plataforma = $Path2D/PathFollow2D

onready var area_contato = $Contato_jogador
onready var area_interacao = $AreaInteracao

onready var texto_ajuda = $TextoAjuda

var plataforma_movendo = false
var jogador_na_zona_inicial = false

func _ready():
	texto_ajuda.visible = false
	resetar_plataforma()

func _physics_process(delta):
	if jogador_na_zona_inicial:
		if plataforma_movendo:
			texto_ajuda.visible = true
			
			if Input.is_action_just_pressed("interact"):
				resetar_plataforma()
			return
		
		texto_ajuda.visible = false
		return
	
	texto_ajuda.visible = false

func resetar_plataforma():
	plataforma_movendo = false
	if animacao.is_playing():
		animacao.stop()
	caminho_plataforma.unit_offset = 0

func _on_AreaInteracao_body_entered(body):
	if body.is_in_group("player"):
		jogador_na_zona_inicial = true

func _on_AreaInteracao_body_exited(body):
	if body.is_in_group("player"):
		jogador_na_zona_inicial = false

func _on_Contato_jogador_body_entered(body):
	if plataforma_movendo:
		return
	
	if body.is_in_group("player"):
		plataforma_movendo = true
		animacao.play("movendo")
