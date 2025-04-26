extends Node2D

var dialogo_ativo = false

func _ready():
	$Panel.visible = false
	$Panel/BotaoAjudaCombate.connect("pressed", self, "_on_BotaoAjudaCombate_pressed")
	$Panel/BotaoAjudaMovimentacao.connect("pressed", self, "_on_BotaoAjudaMovimentacao_pressed")

func _process(_delta):
	if Input.is_action_just_pressed("falar_tayrin") and not dialogo_ativo:
		abrir_dialogo()

func abrir_dialogo():
	dialogo_ativo = true
	$Panel.visible = true
	$Panel/TextoDialogo.text = "Olá! Como posso te ajudar?"
	$Panel/BotaoAjudaCombate.visible = true
	$Panel/BotaoAjudaMovimentacao.visible = true

func _on_BotaoAjudaCombate_pressed():
	$Panel/TextoDialogo.text = "Use ENTER para atacar e E para uivar!"
	$Panel/BotaoAjudaCombate.visible = false
	$Panel/BotaoAjudaMovimentacao.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	fechar_dialogo()

func _on_BotaoAjudaMovimentacao_pressed():
	$Panel/TextoDialogo.text = "Use WASD para se mover e SHIFT para correr!"
	$Panel/BotaoAjudaCombate.visible = false
	$Panel/BotaoAjudaMovimentacao.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	fechar_dialogo()

func fechar_dialogo():
	$Panel.visible = false
	dialogo_ativo = false

