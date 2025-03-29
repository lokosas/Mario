extends CharacterBody2D

@export var player: CharacterBody2D
@export var Speed: int = 50
@export var Chase_Speed: int = 150
@export var Acceleration: float = 300.0

@onready var sprite: AnimatedSprite2D = $"Blue slime walking"
@onready var ray_cast: RayCast2D = $"Blue slime walking/RayCast2D"
@onready var timer = $Timer

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var right_bounds: Vector2
var left_bounds: Vector2

enum States {WANDER, CHASE}
var current_state = States.WANDER

func _ready():
	left_bounds = self.position + Vector2(-125, 0)
	right_bounds = self.position + Vector2(125, 0)
	sprite.play("default")

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	look_for_player()
	move_and_slide()

func look_for_player():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider == player:
			chase_player()
	elif current_state == States.CHASE:
		stop_chase()

func chase_player():
	timer.stop()
	current_state = States.CHASE

func stop_chase():
	if timer.time_left <= 0:
		timer.start()

func handle_movement(delta: float):
	if current_state == States.WANDER:
		if is_on_wall():
			# Byter riktning om den stöter på en vägg
			sprite.flip_h = not sprite.flip_h
			direction.x *= -1
		else:
			if sprite.flip_h:
				direction = Vector2(1, 0)
			else:
				direction = Vector2(-1, 0)
		velocity.x = direction.x * Speed
	else:
		# Jagar spelaren
		direction = (player.position - position).normalized()
		velocity.x = direction.x * Chase_Speed

func handle_gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func _on_timer_timeout():
	current_state = States.WANDER

func _on_damage_hitbox_body_entered(body):
	queue_free()

func _on_attack_hit_box_body_entered(body):
	Global.KillSignal = 1
