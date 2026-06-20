extends CharacterBody2D

const TILE_SIZE = 50  # tamaño de cada casilla del mapa

@onready var sprite = $Sprite  # referencia al AnimatedSprite2D
@onready var hitbox = $HitBox

var esta_saltando = false  # para no moverse mientras anima el salto

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
