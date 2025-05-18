extends Node2D

var dialogo_ativo = false

func _ready():
	$CanvasLayer/Panel.visible = false
	$CanvasLayer/Panel/BotaoAjudaCombate.connect("pressed", self, "_on_BotaoAjudaCombate_pressed")
	$CanvasLayer/Panel/BotaoAjudaMovimentacao.connect("pressed", self, "_on_BotaoAjudaMovimentacao_pressed")

func _process(_delta):
	if Input.is_action_just_pressed("falar_tayrin") and not dialogo_ativo:
		abrir_dialogo()

func abrir_dialogo():
	dialogo_ativo = true
	$CanvasLayer/Panel.visible = true
	$CanvasLayer/Panel/TextoDialogo.text = "Olá! Como posso te ajudar?"
	$CanvasLayer/Panel/BotaoAjudaCombate.visible = true
	$CanvasLayer/Panel/BotaoAjudaMovimentacao.visible = true

func _on_BotaoAjudaCombate_pressed():
	$CanvasLayer/Panel/TextoDialogo.text = "Use ENTER para atacar e E para uivar!"
	$CanvasLayer/Panel/BotaoAjudaCombate.visible = false
	$CanvasLayer/Panel/BotaoAjudaMovimentacao.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	fechar_dialogo()

func _on_BotaoAjudaMovimentacao_pressed():
	$CanvasLayer/Panel/TextoDialogo.text = "Use WASD para se mover e SHIFT para correr!"
	$CanvasLayer/Panel/BotaoAjudaCombate.visible = false
	$CanvasLayer/Panel/BotaoAjudaMovimentacao.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	fechar_dialogo()

func fechar_dialogo():
	$CanvasLayer/Panel.visible = false
	dialogo_ativo = false

