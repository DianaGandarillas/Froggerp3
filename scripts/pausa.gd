extends Control

@onready var label_record = $CenterContainer/VBoxContainer/LabelRecord
@onready var boton_volver = $CenterContainer/VBoxContainer/Button
@onready var boton_reiniciar = $CenterContainer/VBoxContainer/Button2

func _ready():
	# MUY IMPORTANTE: este nodo debe seguir funcionando aunque el juego esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	label_record.text = "Récord: " + str(Global.record)
	
	boton_volver.pressed.connect(_on_button_pressed)
	boton_reiniciar.pressed.connect(_on_button_2_pressed)

func _on_button_pressed():       # Volver
	get_tree().paused = false
	get_parent().get_parent().reanudar()
	queue_free()  # eliminamos la pantalla de pausa

func _on_button_2_pressed():     # Reiniciar
	get_tree().paused = false
	Global.resetear_juego()
	get_tree().change_scene_to_file("res://scenes/MapaPrincipal.tscn")
