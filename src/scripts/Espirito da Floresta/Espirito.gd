extends Node2D

export(Array, String) var falas = ["Aqui já foi o meu lar.",
	"Eles... eles acabaram com tudo..."]

export var virado_para_direita = false

var indice_fala = 0
var jogador_perto = false
var dialogo_ativo = false

onready var texto_fala = $Dialogo/TextoFala
onready var texto_ajuda = $Dialogo/TextoAjuda
onready var animacao = $Dialogo/AnimationPlayer

func _ready():
	texto_ajuda.visible = false
	texto_fala.visible = false
	
	if virado_para_direita:
		$Grafico/Sprite.flip_h = true
		$Grafico/Sprite.position.x = abs($Grafico/Sprite.position.x) * -1

func _process(_delta):
	if jogador_perto:
		if dialogo_ativo:
			texto_ajuda.visible = false
			return;
		
		texto_ajuda.visible = true
		
		if Input.is_action_just_pressed("interact"):
			mostrar_fala()
			dialogo_ativo = true
		
		return;
	
	texto_ajuda.visible = false

func mostrar_fala():
	texto_fala.text = falas[indice_fala]
	animacao.play("dialogo")

func avancar_fala():
	indice_fala += 1
	if indice_fala < falas.size():
		mostrar_fala()
	else:
		texto_fala.visible = false
		dialogo_ativo = false
		indice_fala = 0

func _on_Detector_body_entered(body):
	if body.is_in_group("player"):
		jogador_perto = true

func _on_Detector_body_exited(body):
	if body.is_in_group("player"):
		jogador_perto = false
