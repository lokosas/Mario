extends Area2D

@export var KIllzone = ""


func _on_body_entered(body):
	if body.name == "Player":
		Global.Lives -= 1
		
		
		if Global.Lives == -1:
			get_tree().quit()
		
		else:
			get_tree().reload_current_scene()
