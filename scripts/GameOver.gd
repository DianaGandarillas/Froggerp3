extends Control

@onready var label_record = $CenterContainer/VBoxContainer/LabelRecord

func _ready():
	label_record.text = "Récord: " + str(Global.record)

func _on_button_pressed():
	Global.resetear_juego()
	get_tree().change_scene_to_file("res://scenes/MapaPrincipal.tscn")
