extends Node2D

var metas_completadas = 0
var metas_totales = 5

@onready var label_vidas = $CanvasLayer/LabelVidas
@onready var label_nivel = $CanvasLayer/LabelNivel      
@onready var label_puntaje = $CanvasLayer/LabelPuntaje

@onready var sonido_nivel = $SonidoNivel

@export var pausa_scene: PackedScene
var pausa_activa = false

func _ready():
	actualizar_hud()
	
func _input(event):
	if event.is_action_pressed("cancel"):
		if not pausa_activa:
			pausar()
			
			
func pausar():
	pausa_activa = true
	get_tree().paused = true
	var pausa = pausa_scene.instantiate()
	$CanvasLayer.add_child(pausa)
	
func reanudar():
	pausa_activa = false

func sumar_meta():
	metas_completadas += 1
	
	# Usamos Global para el puntaje también
	Global.puntaje += 50 
	actualizar_hud()
	print("Puntos: ", Global.puntaje, " | Metas: ", metas_completadas, "/", metas_totales)
	
	if metas_completadas >= metas_totales:
		# ¡Subimos de nivel en la memoria global!
		Global.nivel_actual += 1
		Global.puntaje += 1000 # Bono por pasar de nivel
		Global.vidas = 5
		actualizar_hud()
		
		print("¡NIVEL COMPLETADO! Pasando al nivel: ", Global.nivel_actual)
		
		# Al recargar la escena, las metas se vaciarán solas, 
		# pero los CarLane leerán el nuevo Global.nivel_actual y serán más rápidos.
		#get_tree().reload_current_scene()
		sonido_nivel.play()
		await sonido_nivel.finished
		call_deferred("_cambiar_nivel")
		
func _cambiar_nivel():
	get_tree().reload_current_scene()
		
func actualizar_hud():
	label_vidas.text = "Vidas: " + str(Global.vidas)
	label_nivel.text = "Nivel: " + str(Global.nivel_actual)
	label_puntaje.text = "Puntaje: " + str(Global.puntaje)     
	
func jugador_murio():  
	Global.vidas -= 1
	
	if Global.puntaje > Global.record:
		Global.record = Global.puntaje
		
	actualizar_hud()
	if Global.vidas <= 0:
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
	
	
