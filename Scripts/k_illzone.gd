extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Global.KillSignal = 1  # Decrease lives
