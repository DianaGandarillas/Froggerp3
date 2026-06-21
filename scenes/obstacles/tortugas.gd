extends Area2D

@export var velocidad: float = 150.0
@export var direccion: float = 1.0

# ¡NUEVO! Cajas para marcar en el editor
@export var se_sumerge: bool = false 
@export var tiempo_ciclo: float = 3.0 # Segundos entre hundirse y salir

var limite_derecha: float
var limite_izquierda: float
var esta_hundida = false

func _ready():
	# Como las tortugas miran originalmente hacia la IZQUIERDA:
	# Solo volteamos todo el escuadrón si viajan hacia la DERECHA.
	if direccion > 0:
		scale.x = -1
		
	# --- CONFIGURACIÓN DE ANIMACIONES ---
	for nodo in get_children():
		if nodo is AnimatedSprite2D:
			if se_sumerge:
				nodo.play("hundirse") 
			else:
				nodo.play("nadar")    
				
	# --- CÓDIGO DEL TEMPORIZADOR ---
	if se_sumerge:
		var timer = Timer.new()
		timer.wait_time = tiempo_ciclo
		timer.autostart = true
		timer.timeout.connect(_cambiar_estado)
		add_child(timer)

func inicializar():
	var ancho_ventana = get_viewport_rect().size.x
	var ancho_total = $CollisionShape2D.shape.size.x
	limite_derecha   =  ancho_ventana + ancho_total
	limite_izquierda = -ancho_total

func _process(delta):
	# Se mueven igual que los troncos
	position.x += velocidad * direccion * delta
	
	if direccion > 0 and position.x > limite_derecha:
		position.x = limite_izquierda
	elif direccion < 0 and position.x < limite_izquierda:
		position.x = limite_derecha

# Esta función se ejecuta cada vez que el reloj llega a cero
func _cambiar_estado():
	esta_hundida = !esta_hundida # Alternamos el estado
	
	if esta_hundida:
		# 1. Desactivamos la colisión (La rana se caerá al agua porque el agua está debajo)
		$CollisionShape2D.set_deferred("disabled", true)
		# 2. Hacemos las tortugas semi-transparentes para simular que están bajo el agua
		modulate.a = 0.2 
	else:
		# 1. Vuelven a la superficie (reactivamos la colisión)
		$CollisionShape2D.set_deferred("disabled", false)
		# 2. Les devolvemos su color sólido
		modulate.a = 1.0
