extends CharacterBody2D

@export var player: CharacterBody2D
@export var Speed: int = 50
@export var Chase_Speed: int = 150
@export var Acceleration = 300

@onready var Sprite: AnimatedSprite2D = $"Blue slime walking"
@onready var ray_cast: RayCast2D = $"Blue slime walking"/RayCast2D
@onready var timer = $Timer

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2

enum States {
	Wander,
	Chase
}
var Current_state = States.Wander

func _ready():
	left_bounds = self.position + Vector2(-125, 0)
	right_bounds = self.position + Vector2(125, 0)
	$"Blue slime walking".play("default")

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	look_for_player()
	
	# Move the character based on the updated velocity
	move_and_slide()

func look_for_player():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider == player:
			chase_player()
		elif Current_state == States.Chase:
			stop_chase()
	elif Current_state == States.Chase:
		stop_chase()

func chase_player() -> void:
	timer.stop()
	Current_state = States.Chase

func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()

func handle_movement(delta: float) -> void:
	if Current_state == States.Wander:
		if Sprite.flip_h:
			# Moving right
			if self.position.x <= right_bounds.x:
				direction = Vector2(1, 0)
			else:
				# Change direction to left
				Sprite.flip_h = false
				ray_cast.target_position = Vector2(-125, 0)
		else:
			# Moving left
			if self.position.x >= left_bounds.x:
				direction = Vector2(1, 0)
			else:
				# Change direction to right
				Sprite.flip_h = true
				ray_cast.target_position = Vector2(125, 0)
	else:
		# Chasing the player
		direction = (player.position - self.position).normalized()
	
	# Update the velocity based on the direction and speed
	velocity.x = direction.x * Speed  # Use Chase_Speed if in Chase state

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta  # Apply gravity
	else:
		velocity.y = 0  # Reset vertical velocity when on the floor

func _on_timer_timeout():
	Current_state = States.Wander


func _on_damage_hitbox_body_entered(body):
	if body.name == "Player":
		queue_free()


func _on_attack_hit_box_body_entered(body):
	if body.name == "Player":
		print ("Kill Player")
		Global.KillSignal = true
