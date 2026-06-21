extends CharacterBody2D

const TILE_SIZE = 50  # tamaño de cada casilla del mapa

@onready var sprite = $Sprite  # referencia al AnimatedSprite2D
@onready var hitbox = $HitBox

var esta_saltando = false  # para no moverse mientras anima el salto
var en_plataforma = false
var velocidad_plataforma = 0.0

# NUEVA VARIABLE: Para saber si ya estamos en proceso de morir
var esta_muerto = false 

func _ready():
	sprite.animation_finished.connect(_on_animation_finished)
	hitbox.area_entered.connect(_on_area_entered)
	sprite.play("idle")
	
func morir():
	# Si ya está muerto, ignoramos la orden para que la animación fluya
	if esta_muerto: 
		return
		
	esta_muerto = true
	esta_saltando = true # Bloqueamos el movimiento
	sprite.play("muerte")

func ganar():
	# Bloqueamos el movimiento para que el jugador no siga saltando
	esta_saltando = true 
	
	print("¡OBJETIVO COMPLETADO!")
	
	# Aquí podemos reiniciar el nivel entero como si fuera un nivel nuevo
	get_tree().reload_current_scene()

func _on_area_entered(area: Area2D):
	if area.is_in_group("peligro"):
		morir()
	elif area.is_in_group("meta"):
		ganar()

func _input(event):
	# Bloqueamos input si ya está en medio de un salto O si ya murió
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
	
	# Mover la posición inmediatamente (movimiento por casillas)
	position += direccion * TILE_SIZE
	
	# Rotar/voltear el sprite según la dirección
	match direccion:
		Vector2.UP:
			sprite.rotation_degrees = 0      # mira arriba 
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
	# Cuando termina el salto, si no hemos muerto, vuelve a idle
	if sprite.animation == "jump" and not esta_muerto:
		sprite.play("idle")
		esta_saltando = false
	elif sprite.animation == "muerte":
		get_tree().reload_current_scene()
		
func _process(delta):
	# Si ya estamos muertos, dejamos de revisar colisiones
	if esta_muerto:
		return 
		
	# 1. Asumimos que no estamos en el agua ni en el tronco
	en_plataforma = false
	velocidad_plataforma = 0.0
	var en_agua = false
	
	# 2. Escaneamos TODO lo que la rana está tocando AHORA MISMO
	var areas_tocadas = hitbox.get_overlapping_areas() 
	
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
		# Si tocamos agua y NO estamos en un tronco, morimos (solo se llamará 1 vez gracias a 'esta_muerto')
		morir()
