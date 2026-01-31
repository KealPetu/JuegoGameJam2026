class_name Character extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Atributos compartidos por TODOS (Jugador, Enemigos, Jefes)
@export var velocidad_movimiento: float = 200.0
@export var vidas_maximas: int = 1
@export var empuje_al_recibir_dano: float = 300.0

var vidas_actuales: int
var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D # Asumimos que todos tendrán un Sprite llamado así

func _ready():
	vidas_actuales = vidas_maximas

func _physics_process(delta):
	aplicar_gravedad(delta)
	comportamiento_movimiento(delta) # Función "virtual" que cada hijo personalizará
	move_and_slide()

func aplicar_gravedad(delta):
	if not is_on_floor():
		velocity.y += gravedad * delta

# Esta función está vacía a propósito. Los hijos la "sobreescribirán".
func comportamiento_movimiento(_delta):
	velocity.x = 0

func recibir_dano(cantidad: int, origen_dano: Vector2 = Vector2.ZERO):
	vidas_actuales -= cantidad
	print(name, " recibió daño. Vidas restantes: ", vidas_actuales)
	
	# Feedback visual (parpadeo rojo)
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	# Empuje simple hacia el lado contrario del golpe
	if origen_dano != Vector2.ZERO:
		var direccion_empuje = (global_position - origen_dano).normalized()
		velocity = direccion_empuje * empuje_al_recibir_dano
	
	if vidas_actuales <= 0:
		morir()

func morir():
	queue_free() # Por defecto desaparece, pero el jugador puede cambiar esto
