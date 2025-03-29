extends Node2D


func _process(delta):
	$Camera2D.position.x = $Marsian_Player.position.x
	$GPUParticles2D.position.x = $Marsian_Player.position.x


func _on_go_to_next_lvl_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
