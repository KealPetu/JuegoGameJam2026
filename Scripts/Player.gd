extends Character

@export var fuerza_salto: float = -500.0
@onready var attack_area: Area2D = $AttackArea
@onready var attack_collision_shape: CollisionShape2D = $AttackArea/AttackCollisionShape

func _ready():
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_collision_shape.disabled = true
	attack_collision_shape.rotation_degrees = -90.0
	attack_collision_shape.scale.y = 15.0
	collision_shape_2d.scale = Vector2(6.0, 6.0)

# Sobreescribimos la función de movimiento del padre
func comportamiento_movimiento(_delta):
	# Salto
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = fuerza_salto

	# Movimiento Horizontal
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * velocidad_movimiento
		
		# Voltear Sprite y Area de Ataque
		if direction > 0:
			sprite.flip_h = false
			attack_collision_shape.rotation = -abs(attack_collision_shape.rotation)
		else:
			sprite.flip_h = true
			attack_collision_shape.rotation = abs(attack_collision_shape.rotation)
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad_movimiento)

	# Ataque
	if Input.is_action_just_pressed("attack"):
		atacar()

func atacar():
	print("¡Zas!")
	attack_collision_shape.disabled = false
	await get_tree().create_timer(0.2).timeout
	attack_collision_shape.disabled = true

# Sobreescribimos morir para reiniciar el nivel en vez de borrar al jugador
func morir():
	print("GAME OVER")
	get_tree().reload_current_scene()

func _on_attack_area_body_entered(body):
	if body is Character and body != self:
		body.recibir_dano(1, global_position)
