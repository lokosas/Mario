extends Control

func _ready():
	get_tree().paused = true  # Pause game when death screen appears

func _on_retry_button_pressed():
	get_tree().paused = false
	Global.Lives = 3  # Reset lives
	get_tree().reload_current_scene()  # Restart level
	queue_free()  # Remove death screen

func _on_quit_button_pressed():
	get_tree().quit()  # Quit game
