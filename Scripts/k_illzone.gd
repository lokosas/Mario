extends Area2D

@export var Killzone = ""

func _on_Killzone_body_entered(body):
	if body.name == "Marsian_player":  # Ensure the player node is named correctly
		Global.Lives -= 1  # Decrease lives
		print("Lives left:", Global.Lives)  # Debugging output

		if Global.Lives < 0:
			get_tree().quit()  # Quit the game if lives are exhausted
		else:
			get_tree().reload_current_scene()  # Reload the current scene if lives are still available
