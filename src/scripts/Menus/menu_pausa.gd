extends Control

signal continuar_pressed
signal menu_pressed

func _on_Botao_Continuar_pressed():
	emit_signal("continuar_pressed")

func _on_Botao_Menu_pressed():
	emit_signal("menu_pressed")
