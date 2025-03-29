extends Control

func _on_retry_button_up() -> void:
	Global.reloadSettings()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_quit_button_up() -> void:
	get_tree().quit()  # Quit game
