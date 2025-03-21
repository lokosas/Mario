extends CharacterBody2D

enum State {IDLE, SPRINT, JUMP, FALLING, LONG_FALLING}

var current_state = State.IDLE
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var MaxFallSpeed = 200.0
@export var Speed = 200.0
@export var JumpForce = 400.0

var Accel = 16.0
var Friction = 0.8
var AirControl = 0.8
var StopThreshold = 10.0
var PlayerStartPosition = Vector2()

func _ready():
	PlayerStartPosition = self.position

func _physics_process(delta):
	velocity.x = clamp(velocity.x, -Speed, Speed)

	if Input.is_action_just_pressed("Respawn"):
		self.position = PlayerStartPosition

	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > MaxFallSpeed:
			velocity.y = MaxFallSpeed

	handle_state(delta)
	move_and_slide()

	if Global.KillSignal == true:
		Global.KillSignal = false
		Global.Lives -= 1
		if Global.Lives == -1:
			get_tree().quit()
		else:
			get_tree().reload_current_scene()

func handle_state(delta):
	match current_state:
		State.IDLE:
			velocity.x = lerp(velocity.x, 0.0, Friction * delta * 10)
			if abs(velocity.x) < StopThreshold:
				velocity.x = 0
			if Input.is_action_pressed("Right") or Input.is_action_pressed("Left"):
				current_state = State.SPRINT
				$AnimationPlayer.play("Sprint")
			elif Input.is_action_just_pressed("Jump") and is_on_floor():
				jump()
			elif not is_on_floor():
				current_state = State.FALLING

		State.SPRINT:
			if Input.is_action_pressed("Right"):
				velocity.x += Accel * delta * 50
				$Sprite2D.scale.x = 1
			elif Input.is_action_pressed("Left"):
				velocity.x -= Accel * delta * 50
				$Sprite2D.scale.x = -1
			else:
				current_state = State.IDLE
				$AnimationPlayer.play("Idle")

			if Input.is_action_just_pressed("Jump") and is_on_floor():
				jump()

		State.JUMP, State.FALLING, State.LONG_FALLING:
			if Input.is_action_pressed("Right"):
				velocity.x += Accel * delta * 50 * AirControl
				$Sprite2D.scale.x = 1
			elif Input.is_action_pressed("Left"):
				velocity.x -= Accel * delta * 50 * AirControl
				$Sprite2D.scale.x = -1

			if velocity.y >= 0 and current_state == State.JUMP:
				current_state = State.FALLING

			if velocity.y > MaxFallSpeed * 0.75 and current_state == State.FALLING:
				current_state = State.LONG_FALLING

			if is_on_floor():
				current_state = State.IDLE

func jump():
	current_state = State.JUMP
	velocity.y = -JumpForce
	if has_node("Jumpsound"):
		$Jumpsound.play(0.14)
