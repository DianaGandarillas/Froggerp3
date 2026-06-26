extends CharacterBody2D

const TILE_SIZE = 50

@onready var sprite = $Sprite
@onready var hitbox = $HitBox

@onready var sonido_movimiento = $SonidoMovimiento
@onready var sonido_muerte = $SonidoMuerte

var esta_saltando = false
var en_plataforma = false
var velocidad_plataforma = 0.0
var posicion_inicial: Vector2
var esta_muerto = false

func _ready():
	posicion_inicial = global_position
	sprite.animation_finished.connect(_on_animation_finished)
	hitbox.area_entered.connect(_on_area_entered)
	sprite.play("idle")

func morir():
	if esta_muerto:
		return

	esta_muerto = true
	esta_saltando = true
	get_parent().jugador_murio()
	if Global.vidas > 0:
		sprite.play("muerte")
		sonido_muerte.play()

func reiniciar_posicion():
	global_position = posicion_inicial
	sprite.rotation_degrees = 0
	sprite.play("idle")
	esta_saltando = true   # mantenemos bloqueado
	esta_muerto = true     # mantenemos bloqueado

	# Usamos un timer para habilitar el control un momento después
	var timer = get_tree().create_timer(0.1)
	await timer.timeout
	esta_muerto = false
	esta_saltando = false

func ganar():
	esta_saltando = true
	get_tree().reload_current_scene()

func _on_area_entered(area: Area2D):
	if esta_muerto:
		return

	if area.is_in_group("peligro"):
		morir()
	elif area.is_in_group("meta"):
		if area.ocupar():
			esta_muerto = true    # bloqueamos TODO inmediatamente
			esta_saltando = true
			get_parent().sumar_meta()
			reiniciar_posicion()

func _input(event):
	if esta_saltando or esta_muerto:
		return

	if event.is_action_pressed("up"):
		saltar(Vector2.UP)
	elif event.is_action_pressed("down"):
		saltar(Vector2.DOWN)
	elif event.is_action_pressed("left"):
		saltar(Vector2.LEFT)
	elif event.is_action_pressed("right"):
		saltar(Vector2.RIGHT)

func saltar(direccion: Vector2):
	esta_saltando = true
	position += direccion * TILE_SIZE

	match direccion:
		Vector2.UP:
			sprite.rotation_degrees = 0
			sprite.flip_h = false
		Vector2.DOWN:
			sprite.rotation_degrees = 180
			sprite.flip_h = false
		Vector2.LEFT:
			sprite.rotation_degrees = 90
			sprite.flip_h = false
		Vector2.RIGHT:
			sprite.rotation_degrees = -90
			sprite.flip_h = false

	sprite.play("jump")
	sonido_movimiento.play()

func _on_animation_finished():
	if sprite.animation == "jump" and not esta_muerto:
		sprite.play("idle")
		esta_saltando = false
	elif sprite.animation == "muerte":
		reiniciar_posicion()

func _process(delta):
	if esta_muerto:
		return

	en_plataforma = false
	velocidad_plataforma = 0.0
	var en_agua = false

	var areas_tocadas = hitbox.get_overlapping_areas()

	for area in areas_tocadas:
		if area.is_in_group("plataforma"):
			en_plataforma = true
			velocidad_plataforma = area.velocidad * area.direccion
		elif area.is_in_group("agua"):
			en_agua = true

	if en_plataforma:
		position.x += velocidad_plataforma * delta
	elif en_agua:
		morir()
	
	var pantalla = get_viewport_rect()
	if global_position.x < 0 or global_position.x > pantalla.size.x \
	or global_position.y < 0 or global_position.y > pantalla.size.y:
		morir()
		
