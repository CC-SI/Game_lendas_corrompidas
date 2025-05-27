extends Control

signal renascer_pressed
signal menu_pressed

func _on_Botao_Renascer_pressed():
	emit_signal("renascer_pressed")
	
func _on_Botao_Menu_pressed():
	emit_signal("menu_pressed")
