extends Area2D
@export var PathNextLvl = ""

func _on_body_entered(body: Node2D) -> void:
	
	if body.name == "Marsian_Player":
		get_tree().change_scene_to_file(PathNextLvl)
