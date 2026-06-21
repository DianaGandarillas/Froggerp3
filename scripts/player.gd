extends CharacterBody2D

const TILE_SIZE = 50  # tamaño de cada casilla del mapa

@onready var sprite = $Sprite  # referencia al AnimatedSprite2D
@onready var hitbox = $HitBox

var esta_saltando = false  # para no moverse mientras anima el salto
var en_plataforma = false
var velocidad_plataforma = 0.0

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)
	hitbox.area_entered.connect(_on_area_entered)
	sprite.play("idle")
	
func morir():
	esta_saltando = true
	sprite.play("muerte")
	
func _on_area_entered(area: Area2D):
	if area.is_in_group("peligro"):
		morir()

func _input(event):
	# Bloqueamos input si ya está en medio de un salto
	if esta_saltando:
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
	
	# Mover la posición inmediatamente (movimiento por casillas)
	position += direccion * TILE_SIZE
	
	# Rotar/voltear el sprite según la dirección
	match direccion:
		Vector2.UP:
			sprite.rotation_degrees = 0      # mira arriba (posición original)
			sprite.flip_h = false
		Vector2.DOWN:
			sprite.rotation_degrees = 180    # mira abajo
			sprite.flip_h = false
		Vector2.LEFT:
			sprite.rotation_degrees = 90     # mira a la izquierda
			sprite.flip_h = false
		Vector2.RIGHT:
			sprite.rotation_degrees = -90    # mira a la derecha
			sprite.flip_h = false
	
	# Reproducir animación de salto
	sprite.play("jump")
	

func _on_animation_finished():
	# Cuando termina el salto, volvé a idle y desbloqueá el input
	if sprite.animation == "jump":
		sprite.play("idle")
		esta_saltando = false
	elif sprite.animation == "muerte":
		get_tree().reload_current_scene()
		
func _process(delta):
	# 1. Asumimos que no estamos en el agua ni en el tronco
	en_plataforma = false
	velocidad_plataforma = 0.0
	var en_agua = false
	
	# 2. Escaneamos TODO lo que la rana está tocando AHORA MISMO
	# Reemplaza "$HitBox" por el nombre de tu nodo Area2D de la rana si se llama distinto
	var areas_tocadas = $HitBox.get_overlapping_areas() 
	
	# 3. Revisamos una por una las cosas que estamos tocando
	for area in areas_tocadas:
		if area.is_in_group("plataforma"):
			en_plataforma = true
			velocidad_plataforma = area.velocidad * area.direccion
		elif area.is_in_group("agua"):
			en_agua = true

	# 4. Aplicamos la lógica de vida o muerte
	if en_plataforma:
		# Si estamos en el tronco, nos movemos con él
		position.x += velocidad_plataforma * delta
	elif en_agua:
		# Si tocamos agua y NO estamos en un tronco, morimos
		morir()


# Función auxiliar para chequear el agua al saltar
func _revisar_caida_agua():
	# get_overlapping_areas() devuelve todas las áreas que estamos tocando ahora mismo
	var areas = $HitBox.get_overlapping_areas() # Cambia $HitBox por el nombre de tu nodo Area2D
	for a in areas:
		if a.is_in_group("agua") and not en_plataforma:
			morir()
