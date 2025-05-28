extends Control

onready var player = $"../../Player"

onready var tecla_a = $"InfoMovimentação/A"
onready var tecla_d = $"InfoMovimentação/D"
onready var tecla_shift = $InfoDash/Shift
onready var tecla_espaco = $InfoPulo/Espaco
onready var tecla_e = $InfoUivo/E
onready var tecla_w = $InfoMordida/W
onready var tecla_q = $InfoBolaFogo/Q

onready var timer_cooldown_uivo = $"../../Player/UivoCooldown"
onready var timer_cooldown_fogo = $"../../Player/BolaFogoCooldown"
onready var timer_cooldown_dash = $"../../Player/DashCooldown"

onready var cooldown_uivo = $CooldownUivo
onready var cooldown_fogo = $CooldownBolaFogo
onready var cooldown_dash = $CooldownDash

onready var info_cooldown_uivo = $CooldownUivo/Label
onready var info_cooldown_dash = $CooldownDash/Label
onready var info_cooldown_fogo = $CooldownBolaFogo/Label
onready var info_pulo = $ContagemPulos/Label

var esta_cooldown_uivo = false
var esta_cooldown_dash = false
var esta_cooldown_fogo = false

func _process(delta):
	atualizar_contagem_pulo(player.pulos_restantes)
	
	if esta_cooldown_dash:
		atualizar_cooldown_dash()
	
	if esta_cooldown_fogo:
		atualizar_cooldown_fogo()
	
	if esta_cooldown_uivo:
		atualizar_cooldown_uivo()

func atualizar_cooldown_dash():
	info_cooldown_dash.text = "%.1f" % timer_cooldown_dash.time_left

func atualizar_cooldown_fogo():
	info_cooldown_fogo.text = "%.1f" % timer_cooldown_fogo.time_left

func atualizar_cooldown_uivo():
	info_cooldown_uivo.text = "%.1f" % timer_cooldown_uivo.time_left

func atualizar_contagem_pulo(contagem):
	info_pulo.text = str(contagem)

func exibir_cooldown_dash(visivel):
	esta_cooldown_dash = visivel
	cooldown_dash.visible = visivel

func exibir_cooldown_fogo(visivel):
	esta_cooldown_fogo = visivel
	cooldown_fogo.visible = visivel

func exibir_cooldown_uivo(visivel):
	esta_cooldown_uivo = visivel
	cooldown_uivo.visible = visivel

func pintar_tecla(tecla):
	tecla.modulate = Color("#29378a")

func formatar_cor_tecla(tecla):
	tecla.modulate = Color(1,1,1,1)

func _input(event):
	if event.is_action_pressed("ui_left"):
		pintar_tecla(tecla_a)
	if event.is_action_pressed("ui_right"):
		pintar_tecla(tecla_d)
	if event.is_action_pressed("ui_accept"):
		pintar_tecla(tecla_espaco)
	if event.is_action_pressed("dash"):
		pintar_tecla(tecla_shift)
	if event.is_action_pressed("mordida"):
		pintar_tecla(tecla_w)
	if event.is_action_pressed("uivo"):
		pintar_tecla(tecla_e)
	if event.is_action_pressed("atirar"):
		pintar_tecla(tecla_q)
	
	if event.is_action_released("ui_left"):
		formatar_cor_tecla(tecla_a)
	if event.is_action_released("ui_right"):
		formatar_cor_tecla(tecla_d)
	if event.is_action_released("ui_accept"):
		formatar_cor_tecla(tecla_espaco)
	if event.is_action_released("dash"):
		formatar_cor_tecla(tecla_shift)
	if event.is_action_released("mordida"):
		formatar_cor_tecla(tecla_w)
	if event.is_action_released("uivo"):
		formatar_cor_tecla(tecla_e)
	if event.is_action_released("atirar"):
		formatar_cor_tecla(tecla_q)

func _on_DashCooldown_timeout():
	exibir_cooldown_dash(false)

func _on_BolaFogoCooldown_timeout():
	exibir_cooldown_fogo(false)

func _on_UivoCooldown_timeout():
	exibir_cooldown_uivo(false)
