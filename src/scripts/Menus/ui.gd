extends CanvasLayer

onready var menu_pausa = $Pausa
onready var game_over = $GameOver
onready var animacao = $"../Animacao/AnimationPlayer"
onready var player = $"../Player/Player"

var fase = null

func _ready():
	player.connect("jogador_morto", self, "_on_Player_jogador_morto")

func associar_fase(node):
	fase = node

func _input(event):
	if event.is_action_pressed("pausar") and fase != null:
		if fase.estado == "pausado":
			fechar_menu_pausa()
		elif fase.estado == "gameplay":
			abrir_menu_pausa()

func abrir_menu_pausa():
	fase.estado = "pausado"
	get_tree().paused = true
	animacao.play("transicao_nevoa")
	yield(animacao, "animation_finished")
	menu_pausa.show()
	animacao.play_backwards("transicao_nevoa")

func fechar_menu_pausa():
	animacao.play("transicao_nevoa")
	yield(animacao, "animation_finished")
	menu_pausa.hide()
	fase.estado = "gameplay"
	get_tree().paused = false
	animacao.play_backwards("transicao_nevoa")

func abrir_menu_game_over():
	fase.estado = "game_over"
	get_tree().paused = true
	animacao.play("transicao_preta")
	yield(animacao, "animation_finished")
	game_over.show()
	animacao.play_backwards("transicao_preta")

func ir_pro_menu():
	animacao.play("transicao_preta")
	yield(animacao, "animation_finished")
	get_tree().paused = false
	get_tree().change_scene("res://src/Cenas/Telas/Menu Principal.tscn")

func _on_Pausa_continuar_pressed():
	fechar_menu_pausa()

func _on_Pausa_menu_pressed():
	ir_pro_menu()

func _on_Game_Over_renascer_pressed():
	animacao.play("transicao_preta")
	yield(animacao, "animation_finished")
	get_tree().paused = false
	get_tree().change_scene(get_tree().current_scene.filename)

func _on_Game_Over_menu_pressed():
	ir_pro_menu()

func _on_Player_jogador_morto():
	abrir_menu_game_over()

func _on_Pausa_recomecar_pressed():
	animacao.play("transicao_preta")
	yield(animacao, "animation_finished")
	get_tree().paused = false
	get_tree().change_scene(get_tree().current_scene.filename)
