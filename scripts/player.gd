extends CharacterBody2D


@export var speed := 200

@onready var sprite := $Sprite2D

var moving := false


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * speed
		moving = true
	else:
		velocity = Vector2.ZERO
		moving = false

	move_and_slide()

	_update_sprite()
	
	
	
	
func _update_sprite():
	if moving:
		sprite.texture = preload("res://assets/sprites/frog0001.png")
	else:
		sprite.texture = preload("res://assets/sprites/frog0000.png")
