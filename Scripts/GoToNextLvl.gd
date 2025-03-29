extends Area2D
@export var PathNextLvl = ""
@onready var sprite:AnimatedSprite2D =  $AnimatedSprite2D
func _ready():
	sprite.play("loop")

func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file(PathNextLvl)
