extends Node2D

export(Array, String) var falas = ["Aqui já foi o meu lar.",
	"Eles... eles acabaram com tudo..."]

var indice_fala = 0
var jogador_perto = false
var dialogo_ativo = false

func _ready():
	$LabelAviso.visible = false
	$Panel.visible = false

func _process(_delta):
	if jogador_perto and Input.is_action_just_pressed("interact") and not dialogo_ativo:
		mostrar_fala()
		dialogo_ativo = true
		$LabelAviso.visible = false

	elif dialogo_ativo and Input.is_action_just_pressed("next_dialogue"):
		avancar_fala()

func mostrar_fala():
	$Panel.visible = true
	$Panel/Label.text = falas[indice_fala]

func avancar_fala():
	indice_fala += 1
	if indice_fala < falas.size():
		mostrar_fala()
	else:
		$Panel.visible = false
		dialogo_ativo = false
		indice_fala = 0

func _on_Detector_body_entered(body):
	if body.name == "Jogador":  
		jogador_perto = true
		$LabelAviso.visible = true

func _on_Detector_body_exited(body):
	if body.name == "Jogador":
		jogador_perto = false
		$LabelAviso.visible = false
		$Panel.visible = false
		dialogo_ativo = false
		indice_fala = 0
