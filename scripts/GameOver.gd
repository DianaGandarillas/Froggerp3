extends Control

func _on_button_pressed():
	Global.resetear_juego()
	get_tree().change_scene_to_file("res://scenes/MapaPrincipal.tscn")
